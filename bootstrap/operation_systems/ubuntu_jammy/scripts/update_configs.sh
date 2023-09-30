#!/bin/bash
export $(grep -v '^#' ../.env | xargs)
source ../passwords/.env

echo "----- Enable autoinstall  -----"
sed -i -e 's/---/ autoinstall  ---/g' $BUILD_DIR/boot/grub/grub.cfg
sed -i -e 's/---/ autoinstall  ---/g' $BUILD_DIR/boot/grub/loopback.cfg
sed -i -e 's,---, ds=nocloud\\\\\\;s=/cdrom/nocloud/  ---,g'  $BUILD_DIR/boot/grub/grub.cfg
sed -i -e 's,---, ds=nocloud\\\\\\;s=/cdrom/nocloud/  ---,g' $BUILD_DIR/boot/grub/loopback.cfg

echo "----- Add preseed file -----"
mkdir --parents $BUILD_DIR/nocloud/
cat ../data/user-data | envsubst > $BUILD_DIR/nocloud/user-data
touch "$BUILD_DIR/nocloud/meta-data"

echo "----- Calculating MD5 sums -----"
rm $BUILD_DIR/md5sum.txt
(cd $BUILD_DIR/ && find . -type f -print0 | xargs -0 md5sum | grep -v "boot.cat" | grep -v "md5sum.txt" > md5sum.txt)
