#!/bin/bash

sudo apt install -y --no-install-recommends xserver-xorg-core xserver-xorg xfonts-base xinit xfce4 desktop-base lightdm xloadimage fbi fim imagemagick ffmpeg vlc omxplayer xfce4-goodies inotify-tools scrot

echo "Installing log2ram from https://github.com/azlux/log2ram - see instructions there if this fails..."
echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -
sudo apt update
sudo apt install -y log2ram
