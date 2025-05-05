# Installing fish
sudo pacman -S fish --noconfirm
sudo chsh -s /usr/bin/fish

# Install oh-my-fish
git clone https://github.com/oh-my-fish/oh-my-fish
cd oh-my-fish
bin/install
omf install zish
