#!/bin/bash

scripts/camgridinstallscripts.sh

camgridinstallaptpackages.sh

echo "Preconfiguring your xfce4-panel to not pop up and ask for default config setup"
cp -vf /etc/xdg/xfce4/panel/default.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

camgridinstallservice.sh

echo "Next you should configure the Pi to auto login into desktop so xwindow is active and ready for the camgrid..."
read -rsp $'Press any key to continue...\n' -n1 key

sudo raspi-config
