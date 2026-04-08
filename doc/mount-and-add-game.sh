#!/bin/bash
# Script to mount ReactOS disk image and add your game

set -e

IMAGES_DIR="/home/snake/projects/nedelchev.org/assets/v86/images"
HDD_IMAGE="$IMAGES_DIR/reactos.img"
MOUNT_POINT="/tmp/reactos_mount"
GAME_DIR="/home/snake/projects/nedelchev.org/game"

echo "===================================="
echo "Adding Game to ReactOS Image"
echo "===================================="

# Check if game directory exists
if [ ! -d "$GAME_DIR" ]; then
    echo "ERROR: Game directory not found: $GAME_DIR"
    echo "Please create this directory and place your game files there."
    exit 1
fi

# Check if disk image exists
if [ ! -f "$HDD_IMAGE" ]; then
    echo "ERROR: ReactOS disk image not found: $HDD_IMAGE"
    echo "Please run ./setup-reactos.sh first."
    exit 1
fi

# Verify disk format
echo "Checking disk image format..."
FORMAT=$(qemu-img info "$HDD_IMAGE" | grep "file format" | awk '{print $3}')
echo "Disk format: $FORMAT"

if [ "$FORMAT" != "raw" ]; then
    echo ""
    echo "⚠️  WARNING: Disk image is in $FORMAT format, not raw!"
    echo "   v86 requires RAW format. This image won't work in the browser."
    echo ""
    echo "Do you want to convert it to raw format now? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Converting to RAW format..."
        qemu-img convert -f "$FORMAT" -O raw "$HDD_IMAGE" "${HDD_IMAGE%.img}-raw.img"
        mv "$HDD_IMAGE" "${HDD_IMAGE%.img}-${FORMAT}.bak"
        mv "${HDD_IMAGE%.img}-raw.img" "$HDD_IMAGE"
        echo "✓ Converted to RAW format"
    else
        echo "Skipping conversion. Note: Image won't work with v86."
    fi
    echo ""
fi

# Method 1: Using guestfish (if available)
if command -v guestfish &> /dev/null; then
    echo "Using guestfish to add game files..."

    guestfish -a "$HDD_IMAGE" -i <<EOF
mkdir-p /Documents\ and\ Settings/Administrator/Desktop/Game
copy-in $GAME_DIR/* /Documents\ and\ Settings/Administrator/Desktop/Game/
EOF

    echo "Game files copied successfully!"

else
    # Method 2: Using QEMU with a data CD
    echo "Creating ISO with game files..."
    GAME_ISO="$IMAGES_DIR/game-data.iso"

    genisoimage -o "$GAME_ISO" -J -r "$GAME_DIR"

    echo ""
    echo "Game ISO created: $GAME_ISO"
    echo ""
    echo "Now launching ReactOS with game CD mounted..."
    echo "Please manually copy the game from D:\\ to C:\\Game\\"
    echo ""
    echo "Press ENTER to launch QEMU..."
    read

    qemu-system-i386 \
        -m 512 \
        -hda "$HDD_IMAGE" \
        -cdrom "$GAME_ISO" \
        -vga std \
        -net none

    echo ""
    echo "Don't forget to:"
    echo "1. Copy game files from D: to C:\\Game"
    echo "2. Create a shortcut in Startup folder (optional)"
    echo "3. Shut down ReactOS properly"
fi

echo ""
echo "===================================="
echo "Setup Complete!"
echo "===================================="
echo "Your ReactOS image is ready for v86."
echo "Next: Integrate it into your website."
echo ""
