#!/bin/bash
export $(cat ../.env | xargs) && rails c

xorriso -as mkisofs \
   -r -V 'Eiter jammy seeded' \
   -o $IMAGE \
   -J -J -joliet-long -cache-inodes \
   -isohybrid-mbr $MBR_FILE \
   -b isolinux/isolinux.bin \
   -c isolinux/boot.cat \
   -boot-load-size 4 -boot-info-table -no-emul-boot \
   -eltorito-alt-boot \
   -e boot/grub/efi.img \
   -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
    $BUILD_DIR