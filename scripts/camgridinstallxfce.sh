#!/bin/bash

sudo apt install -y --no-install-recommends xserver-xorg-core xserver-xorg xfonts-base xinit xfce4 desktop-base lightdm xloadimage xfce4-goodies scrot

sudo cp -vf "$HOME/picamframegrid/reference/camgrid.xfce.service" "/etc/systemd/user/camgrid.service"
cp -vf "$HOME/picamframegrid/reference/xsessionrc" "$HOME/.xsessionrc"
chmod +x "$HOME/.xsessionrc"
sudo cp -vf "$HOME/picamframegrid/reference/xsession.target" "/etc/systemd/user/"

echo "Preconfiguring your xfce4-panel to not pop up and ask for default config setup"
cp -vf /etc/xdg/xfce4/panel/default.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

systemctl --user daemon-reload
systemctl --user enable camgrid

echo "Next you should configure the Pi to auto login into desktop so xwindow is active and ready for the camgrid..."
read -rsp $'Press any key to continue...\n' -n1 key

sudo raspi-config
