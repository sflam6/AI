# Display, firmware
sudo pacman -Syy && -Syu
sudo pacman -S mesa-vdpau linux-firmware packagekit-qt5 fwupd flatpak linux linux-headers --noconfirm --needed
sudo pacman -S flameshot steam fuse2 unrar libreoffice-still  qt5-wayland qt6-wayland partitionmanager power-profile-daemon --noconfirm --needed
sudo pacman -S fcitx5-im fcitx5-qt fcitx5-gtk fcitx5-table-extra avahi --noconfirm --needed

# Flatpak packages
flatpak install flathub com.spotify.Client com.dropbox.Client org.kde.krita org.winehq.Wine dev.lizardbyte.app.Sunshine