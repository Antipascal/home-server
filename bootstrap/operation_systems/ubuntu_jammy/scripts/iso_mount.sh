#!/bin/bash
export $(grep -v '^#' ../.env | xargs)

echo "----- Downloading image -----"
wget $IMAGE_LINK

echo "----- Cleaning up -----"
rm -rf $BUILD_DIR/
mkdir --parents $BUILD_DIR

echo "----- Mounting image -----"
sudo mount -o loop $IMAGE /mnt/iso

echo "----- Syncing -----"
rsync -av /mnt/iso/ $BUILD_DIR
chmod -R u+w $BUILD_DIR
sudo umount /mnt/iso
echo "----- Done -----"