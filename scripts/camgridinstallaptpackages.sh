#!/bin/bash

sudo apt install -y --no-install-recommends xserver-xorg-core xserver-xorg xfonts-base xinit xfce4 desktop-base lightdm xloadimage fbi fim imagemagick ffmpeg vlc xfce4-goodies inotify-tools scrot
sudo apt install -y --no-install-recommends omxplayer

echo "Installing log2ram from https://github.com/azlux/log2ram - see instructions there if this fails..."
echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -
sudo apt update
sudo apt install -y log2ram

echo "Installing raspi2bmp for framebuffer screenshots..."
pushd ~
git clone https://github.com/ThinhPhan/raspi2bmp.git
pushd raspi2bmp
make
sudo cp raspi2bmp /usr/local/bin/
popd
popd
