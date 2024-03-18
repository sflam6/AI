#!/usr/bin/env bash

echo "Please enter your username"
read USER 

echo "Please enter your password"
read PASSWORD 

# make filesystems
echo -e "\nCreating Filesystems...\n"

mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

# mount target
mount /dev/nvme0n1p3 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot/

echo "--------------------------------------"
echo "-- INSTALLING Arch Linux BASE on Main Drive       --"
echo "--------------------------------------"
pacstrap -K /mnt base base-devel --noconfirm --needed

# kernel
pacstrap -K /mnt linux linux-firmware --noconfirm --needed

echo "--------------------------------------"
echo "-- Setup Dependencies               --"
echo "--------------------------------------"

pacstrap /mnt networkmanager vim intel-ucode bluez bluez-utils blueman openssh fakeroot git --noconfirm --needed

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

useradd -m $USER
usermod -aG wheel,storage,power,audio $USER
echo $USER:$PASSWORD | chpasswd
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

echo "-------------------------------------------------"
echo "Setup Language to US and set locale"
echo "-------------------------------------------------"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

ln -sf /usr/share/zoneinfo/Asia/HongKong /etc/localtime
hwclock --systohc

echo "arch" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1	localhost
::1			localhost
127.0.1.1	arch.localdomain	arch
EOF

echo "-------------------------------------------------"
echo "Display and Audio Drivers"
echo "-------------------------------------------------"

pacman -S xorg pulseaudioxorg-server pipewire wireplumber pipewire-pulse nvtop --noconfirm --needed

systemctl enable NetworkManager bluetooth

#DESKTOP ENVIRONMENT
pacman -S plasma sddm plasma-meta plasma-workspace packagekit-qt5 --noconfirm --needed
pacman -S firefox noto-fonts-cjk noto-fonts-emoji --noconfirm --needed
pacman -S flameshot steam fuse2 unrar libreoffeice-still --noconfirm --needed
pacman -S fcitx5-im fcitx5-qt fcitx5-gtk fcitx5-table-extra --noconfirm --needed
systemctl enable sddm sshd

echo "-------------------------------------------------"
echo "Install Complete, You can reboot now"
echo "-------------------------------------------------"

#Grub
pacman -S grub efibootmgr
mount /dev/nvme0n1p1 /boot
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

unmount /mnt/boot
unmount /mnt
shutdown now
