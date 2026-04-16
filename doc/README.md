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

## 5. Compress the state file

Compress the state file with zstd to reduce download size from ~119 MB to ~20 MB:

```bash
cd assets/v86/images && zstd -19 reactos.state.bin -o reactos.state.bin.zst
```

v86 detects the `.zst` extension and automatically decompresses the state file before restoring. This achieves ~83% size reduction with no code changes required.

## 6. Split the disk image into chunks

Large disk images can be split into fixed-size chunks for serving. Each chunk file is named `<stem>-<start>-<end>.<ext>`.

```
Usage: split-image.py [--zstd|--gzip] partsize filename-in filename-out-with-%d-%d
```

- **`partsize`** — chunk size; supports `k`/`kb` and `m`/`mb` suffixes (e.g. `99m`)
- **`--zstd`** — compress each chunk with `zstd -19` after writing
- **`--gzip`** — compress each chunk with `gzip -9` after writing
- **`filename-out-with-%d-%d`** — output path template; the two `%d` are replaced by the byte offsets of the chunk

Example — split `reactos.img` into 99 MB zstd-compressed chunks:

```bash
python3 doc/split-image.py --zstd 99m \
  assets/v86/images/reactos.img \
  assets/v86/images/chunks/reactos-%d-%d.img
```

This produces files such as:
```
assets/v86/images/chunks/reactos-0-103809024.img.zst
assets/v86/images/chunks/reactos-103809024-207618048.img.zst
...
```
