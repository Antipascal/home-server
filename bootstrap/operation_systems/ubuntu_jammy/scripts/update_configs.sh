#!/bin/bash
export $(cat ../.env | xargs) && rails c

echo "----- Add grub menu entry -----"
cat >> $BUILD_DIR/boot/grub/grub.cfg <<EOF
menuentry "Install Eiter jammy" {
    set gfxpayload=keep
    linux   /casper/vmlinuz  file=/cdrom/preseed/$PRESEED_FILE auto=true priority=critical debian-installer/locale=en_US keyboard-configuration/layoutcode=us ubiquity/reboot=true languagechooser/language-name=English countrychooser/shortlist=US localechooser/supported-locales=en_US.UTF-8 boot=casper automatic-ubiquity initrd=/casper/initrd quiet splash noprompt noshell ---
    initrd  /casper/initrd
}
EOF

echo "----- Add preseed file -----"
read -p "Enter root password: " ROOT_PASSWORD
read -p "Enter password for user $(USER_NAME): " USER_PASSWORD

ROOT_PASSWORD_HASH=$(echo -n $ROOT_PASSWORD | mkpasswd -m sha-512)
USER_PASSWORD_HASH=$(echo -n $USER_PASSWORD | mkpasswd -m sha-512)
cat ../data/custom.seed | envsubst > $BUILD_DIR/preseed/$PRESEED_FILE
