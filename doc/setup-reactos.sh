#!/bin/bash
# ReactOS Disk Image Setup Script for v86
# This script creates a ReactOS hard disk image with your game pre-installed

set -e

IMAGES_DIR="/home/snake/projects/nedelchev.org/assets/v86/images"
REACTOS_ISO="$IMAGES_DIR/ReactOS-0.4.14-live.iso"
HDD_IMAGE="$IMAGES_DIR/reactos.img"
HDD_SIZE="2G"
GAME_DIR="/home/snake/projects/nedelchev.org/game"

echo "===================================="
echo "ReactOS v86 Disk Image Setup"
echo "===================================="

# Step 1: Download ReactOS ISO
echo ""
echo "Step 1: Downloading ReactOS ISO..."
mkdir -p "$IMAGES_DIR"
cd "$IMAGES_DIR"

if [ ! -f "$REACTOS_ISO" ]; then
    echo "Downloading ReactOS 0.4.14 (this may take a few minutes)..."
    wget -O "$REACTOS_ISO" "https://sourceforge.net/projects/reactos/files/ReactOS/0.4.14/ReactOS-0.4.14-iso.zip/download"

    # If it's a zip file, extract it
    if file "$REACTOS_ISO" | grep -q "Zip"; then
        unzip -o "$REACTOS_ISO"
        rm "$REACTOS_ISO"
        mv ReactOS-*.iso "$REACTOS_ISO" 2>/dev/null || true
    fi
else
    echo "ReactOS ISO already exists."
fi

# Step 2: Create empty hard disk image in RAW format
echo ""
echo "Step 2: Creating hard disk image ($HDD_SIZE) in RAW format..."
echo "NOTE: v86 requires RAW format (not qcow2)"
if [ ! -f "$HDD_IMAGE" ]; then
    qemu-img create -f raw "$HDD_IMAGE" "$HDD_SIZE"
    echo "✓ RAW disk image created: $HDD_IMAGE"
    qemu-img info "$HDD_IMAGE"
else
    echo "Hard disk image already exists: $HDD_IMAGE"
    echo "Checking format..."
    qemu-img info "$HDD_IMAGE" | grep "file format"
fi
echo ""

# Step 3: Install ReactOS to the hard disk
echo ""
echo "Step 3: Installing ReactOS to disk image..."
echo "IMPORTANT: You need to manually install ReactOS through QEMU."
echo ""
echo "I will now launch QEMU. Please follow these steps:"
echo "1. Select your language and keyboard layout"
echo "2. Press ENTER to start installation"
echo "3. Select the unpartitioned space and press ENTER"
echo "4. Select 'Format partition using FAT' and press ENTER"
echo "5. Wait for installation to complete"
echo "6. When prompted to restart, shut down QEMU instead"
echo ""
echo "Press ENTER to launch QEMU for ReactOS installation..."
read

qemu-system-i386 \
    -m 512 \
    -cdrom "$REACTOS_ISO" \
    -hda "$HDD_IMAGE" \
    -boot d \
    -vga std \
    -net none

echo ""
echo "✓ Installation complete!"
echo ""

# Step 4: Verify RAW format
echo "===================================="
echo "Step 4: Verifying disk format"
echo "===================================="
echo ""
qemu-img info "$HDD_IMAGE"
echo ""

FORMAT=$(qemu-img info "$HDD_IMAGE" | grep "file format" | awk '{print $3}')
if [ "$FORMAT" = "raw" ]; then
    echo "✓ Disk image is in RAW format - ready for v86!"
else
    echo "⚠️  WARNING: Disk format is $FORMAT, not raw!"
    echo "   v86 requires RAW format. Converting now..."
    qemu-img convert -f "$FORMAT" -O raw "$HDD_IMAGE" "${HDD_IMAGE%.img}-raw.img"
    mv "$HDD_IMAGE" "${HDD_IMAGE%.img}-${FORMAT}.bak"
    mv "${HDD_IMAGE%.img}-raw.img" "$HDD_IMAGE"
    echo "✓ Converted to RAW format"
    qemu-img info "$HDD_IMAGE"
fi
echo ""

echo "===================================="
echo "Next Steps:"
echo "===================================="
echo "1. Place your game executable in: $GAME_DIR"
echo "2. Run: ./mount-and-add-game.sh"
echo "3. Test with: http://localhost:4000/assets/v86/v86-loader.html"
echo "4. Integrate into your website"
echo ""
