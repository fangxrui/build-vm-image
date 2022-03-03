#!/bin/bash

# Echo commands run
set -x

# exit when any command fails
set -e
 

echo "Packaging iso ... "

# might need this before first try: chmod +x lib/scripts/package-iso.sh

# Make iso directort & structure the content
mkdir -p iso
mkdir -p /iso/isolinux
mkdir -p /iso/boot

cp my-vol/vmlinuz iso/boot/
cp my-vol/initrd.img iso/boot/
mv iso/boot/initrd.img iso/boot/initrd

cp vol-syslinux/isolinux.bin iso/isolinux/
cp vol-syslinux/isolinux.cfg iso/isolinux/
cp vol-syslinux/ldlinux.c32 iso/isolinux/

ls -R iso/

# Generate iso
apt-get install -y mkisofs
mkisofs -o jn.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J iso

# Copy iso to volume
cp jn.iso my-vol/
