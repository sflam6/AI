#!/usr/bin/env bash

echo "Please enter your username"
read USER 

echo "Please enter your password"
read PASSWORD 

mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

# mount target
mount /dev/nvme0n1p3 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot/

# kernel
pacstrap -K /mnt base base-devel --noconfirm --needed
pacstrap -K /mnt linux linux-firmware --noconfirm --needed

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

# Display
pacman -S vulkan-radeon libva-mesa-driver mesa-vdpau --noconfirm --needed

#DESKTOP ENVIRONMENT
pacman -S networkmanager vim intel-ucode bluez bluez-utils blueman openssh fakeroot git --noconfirm --needed
pacman -S plasma sddm plasma-meta plasma-workspace packagekit-qt5 --noconfirm --needed
pacman -S fcitx5-im fcitx5-qt fcitx5-gtk fcitx5-table-extra --noconfirm --needed
pacman -S xorg pulseaudioxorg-server pipewire wireplumber pipewire-pulse nvtop --noconfirm --needed
pacman -S firefox noto-fonts-cjk noto-fonts-emoji

useradd -m $USER
usermod -aG wheel,storage,power,audio,storage $USER
echo $USER:$PASSWORD | chpasswd
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# language and zoneinfo
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

ln -sf /usr/share/zoneinfo/Asia/HongKong /etc/localtime
hwclock --systohc

# Host
echo "ArchLinux" >> /etc/hostname
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1	ArchLinux" >> /etc/hosts

# systemservices
systemctl enable sddm.service
systemctl enable sshd.service
systemctl enable bluetooth.service
systemctl enable NetworkManager.service

#Grub
pacman -S grub efibootmgr --noconfirm --needed
mount /dev/nvme0n1p1 /boot
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

exit 
unmount /mnt/boot
unmount /mnt
shutdown now
