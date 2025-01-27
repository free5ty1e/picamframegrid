#!/bin/bash

# --no-install-recommends
sudo apt install -y scrot
#sudo apt install -y xserver-xorg-core xserver-xorg xfonts-base xinit xfce4 desktop-base lightdm xloadimage fbi fim imagemagick vlc xfce4-goodies inotify-tools
# sudo apt install -y --no-install-recommends omxplayer
sudo apt-get install -y libx264-dev
sudo apt-get install -y libraspberrypi-dev raspberrypi-kernel-headers
sudo apt-get install -y ffmpeg

sudo apt-get install -y rsync
pushd ~
echo "Installing log2ram from https://github.com/azlux/log2ram - see instructions there if this fails..."
curl -L https://github.com/azlux/log2ram/archive/master.tar.gz | tar zxf -
cd log2ram-master
chmod +x install.sh && sudo ./install.sh
cd ..
echo "Cleaning up - removing log2ram source..."
rm -rv log2ram-master
sudo systemctl disable log2ram-daily.timer

# echo "Installing raspi2bmp for framebuffer screenshots..."
# sudo apt-get install -y libz-dev
# git clone https://github.com/ThinhPhan/raspi2bmp.git
# pushd raspi2bmp
# make
# sudo cp raspi2bmp /usr/local/bin/
# popd
# echo "Cleaning up - removing raspi2bmp source..."
# rm -rvf raspi2bmp


# echo "Installing raspi2png for framebuffer screenshots..."
# sudo apt-get install -y libz-dev
# sudo apt-get install -y apt-utils
# sudo apt-get install -y libpng-dev
# git clone https://github.com/AndrewFromMelbourne/raspi2png.git
# pushd raspi2png
# make
# sudo cp raspi2png /usr/local/bin/
# popd
# echo "Cleaning up - removing raspi2png source..."
# rm -rvf raspi2png

sudo apt autoremove -y

popd
