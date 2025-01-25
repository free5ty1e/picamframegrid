#!/bin/bash

# --no-install-recommends
sudo apt install -y xserver-xorg-core xserver-xorg xfonts-base xinit xfce4 desktop-base lightdm xloadimage fbi fim imagemagick vlc xfce4-goodies inotify-tools scrot
sudo apt install -y --no-install-recommends omxplayer
sudo apt-get install -y libx264-dev
sudo apt-get install -y ffmpeg

sudo apt-get install -y rsync
pushd ~
echo "Installing log2ram from https://github.com/azlux/log2ram - see instructions there if this fails..."
curl -L https://github.com/azlux/log2ram/archive/master.tar.gz | tar zxf -
cd log2ram-master
chmod +x install.sh && sudo ./install.sh
cd ..
rm -r log2ram-master
sudo systemctl disable log2ram-daily.timer


echo "Installing raspi2bmp for framebuffer screenshots..."
git clone https://github.com/ThinhPhan/raspi2bmp.git
pushd raspi2bmp
make
sudo cp raspi2bmp /usr/local/bin/
popd
popd
