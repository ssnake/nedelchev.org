# v86 ReactOS Setup

## 1. Create the ReactOS disk image

Requires: `qemu-img`, `qemu-system-i386`

```bash
# Create a 2GB raw disk image (raw format required by v86)
qemu-img create -f raw assets/v86/images/reactos.img 2G

# Boot the ReactOS installer ISO and install to the disk image
qemu-system-i386 -m 512 \
  -cdrom assets/v86/images/ReactOS-0.4.14-live.iso \
  -hda assets/v86/images/reactos.img \
  -boot d -vga std -net none
```

Follow the on-screen installer. When done, shut down QEMU.

## 2. Add the game to the image

**Option A — guestfish** (no boot required):

```bash
guestfish -a assets/v86/images/reactos.img -i \
  mkdir-p /Users/Administrator/Desktop/Game : \
  copy-in game/* /Users/Administrator/Desktop/Game/
```

**Option B — mount a game ISO inside QEMU**:

```bash
# Create an ISO from the game folder
genisoimage -o assets/v86/images/game-data.iso -J -r game/

# Boot ReactOS and copy from D:\ to C:\Game\
qemu-system-i386 -m 512 \
  -hda assets/v86/images/reactos.img \
  -cdrom assets/v86/images/game-data.iso \
  -vga std -net none
```

## 3. Run the local dev server

The `serve-test.py` script serves files with HTTP range-request support (required for async disk image loading):

```bash
python3 doc/serve-test.py
# Open: http://localhost:8000/assets/v86/v86-loader.html
```

## 4. Save the VM state

1. Open the loader page and click **Start Emulator**
2. Wait for ReactOS to fully boot and the game to be ready
3. Click **Save State** — saves a snapshot to browser IndexedDB and offers a `.bin` download
4. Download the state file and place it at:
   ```
   assets/v86/images/reactos.state.bin
   ```
5. The about page will load from this snapshot on next visit (~119 MB download, cached after first load)
