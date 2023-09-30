#!/bin/bash
export $(grep -v '^#' ../.env | xargs)

orig=${IMAGE_NAME}.iso
mbr=${IMAGE_NAME}.mbr
efi=${IMAGE_NAME}.efi

# Extract the MBR template
dd if="$orig" bs=1 count=446 of="$mbr"

# Extract EFI partition image
skip=$(/sbin/fdisk -l "$orig" | fgrep '.iso2 ' | awk '{print $2}')
size=$(/sbin/fdisk -l "$orig" | fgrep '.iso2 ' | awk '{print $4}')
dd if="$orig" bs=512 skip="$skip" count="$size" of="$efi"

xorriso -as mkisofs \
  -r -V 'Eiter bionic seeded' -J -joliet-long -l \
  -iso-level 3 \
  -partition_offset 16 \
  --grub2-mbr "$mbr" \
  --mbr-force-bootable \
  -append_partition 2 0xEF "$efi" \
  -appended_part_as_gpt \
  -c /boot.catalog \
  -b /boot/grub/i386-pc/eltorito.img \
    -no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info \
  -eltorito-alt-boot \
  -e '--interval:appended_partition_2:all::' \
    -no-emul-boot \
  -o "$CUSTOM_IMAGE" \
  $BUILD_DIR

sudo cp ./$CUSTOM_IMAGE $BUILD_DIR