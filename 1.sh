#!/usr/bin/env bash

# Update, format, mount; nvme0n1p1-boot, nvme0n1p2-swap, nvme0n1p3-linuxsystem
pacman -Syy && -Syu
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p3
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mount /dev/nvme0n1p3 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

# Linux and chroot
pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
