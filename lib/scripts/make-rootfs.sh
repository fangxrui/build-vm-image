#!/bin/bash

# Echo commands run
set -x

# exit when any command fails
set -e

echo "Running rootfs build script"

# Download base image
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-root.tar.xz

mkdir -p rootfs

# Create raw disk & format disk with ext4 filesystem & mount it onto /rootfs
dd if=/dev/zero of=disk.img bs=1M count=5000
mkfs.ext4 disk.img -L cloudimg-rootfs
mount -o offset=0 disk.img /rootfs/

# Base image
tar -xf focal-server-cloudimg-amd64-root.tar.xz -C rootfs
ls rootfs

# Delete symlink
chroot rootfs ls -l /etc/resolv.conf
chroot rootfs rm /etc/resolv.conf

# Add nameserver to resolv.conf
echo "nameserver 8.8.8.8" | tee rootfs/etc/resolv.conf

# Install necessary packages
chroot rootfs apt-get update 
chroot rootfs apt-get install python3 -y
chroot rootfs apt-get install python3-pip -y
chroot rootfs apt-get install python3-notebook -y 

# dependencies
chroot rootfs pip install pandas
chroot rootfs pip install seaborn
chroot rootfs pip install -U matplotlib

# Create file content
chroot rootfs mkdir data
chroot rootfs wget -P /data https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv

# User & password
chroot rootfs bash -c "groupadd -r ubuntu && useradd -m -r -g ubuntu ubuntu -s /bin/bash"
chroot rootfs bash -c "echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
chroot rootfs bash -c "echo 'ubuntu:ubuntu' | chpasswd"

# Networking
cp /my-vol/01-config.yaml rootfs/etc/netplan/

# This can create a vmlinuz and initrd file in the /boot directory of rootfs.
chroot rootfs apt-get install linux-virtual -y

# Copy to volume in between container runs
cp rootfs/boot/vmlinuz /my-vol
cp rootfs/boot/initrd.img /my-vol

# Copy disk.img to volume
umount /rootfs
cp --sparse=always disk.img /my-vol/disk.img


# #
chmod +x lib/scripts/package-iso.sh

