#!/bin/bash
# Extract kernel + initrd for PXE booting Proxmox ISO

ISO_PATH="./http/proxmox-ve.iso"
TFTP_BOOT_DIR="./tftp/boot"

echo "🔍 Checking for ISO at $ISO_PATH..."
if [ ! -f "$ISO_PATH" ]; then
  echo "❌ ISO not found. Please place the Proxmox ISO at $ISO_PATH"
  exit 1
fi

echo "🗂️ Mounting ISO temporarily..."
MNT_DIR=$(mktemp -d)
sudo mount -o loop "$ISO_PATH" "$MNT_DIR"

echo "📦 Extracting kernel and initrd..."
mkdir -p "$TFTP_BOOT_DIR"
cp "$MNT_DIR/boot/linux26" "$TFTP_BOOT_DIR/vmlinuz"
cp "$MNT_DIR/boot/initrd.img" "$TFTP_BOOT_DIR/initrd.gz"

echo "✅ Extracted to $TFTP_BOOT_DIR"

echo "⏏️ Unmounting ISO..."
sudo umount "$MNT_DIR"
rm -rf "$MNT_DIR"

echo "🎉 Done. You can now PXE boot the Proxmox node."
