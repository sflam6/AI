# Linux packages and services
pacman -S vulkan-radeon libva-mesa-driver mesa-vdpau
pacman -S linux-firmware
pacman -S sudo networkmanager vim firefox noto-fonts-cjk noto-fonts-emoji
pacman -S xorg xorg-server pipewire wireplumber pipewire-pulse intel-ucode nvtop
pacman -S sddm plasma-meta plasma-workspace packagekit-qt5
pacman -S flameshot steam fuse2 unrar libreoffeice-still
pacman -S fcitx5-im fcitx5-qt fcitx5-gtk fcitx5-table-extra
pacman -S git openssh fakeroot base-devel

# Host info
echo "ArchLinux" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 ArchLinux" >> /etc/hosts

# Enable services
systemctl enable sddm.service
systemctl enable NetworkManager.service
systemctl enable sshd.service
systemctl enable bluetooth.service

# User related
passwd
useradd -m -g users -G wheel,audio,video,storage -s /bin/bash user
passwd user
vim /etc/sudoers

# Grub
pacman -S grub efibootmgr
mount /dev/sda1 /boot
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

# Reboot
exit
umount /mnt/boot
umount /mnt
shutdown now 
