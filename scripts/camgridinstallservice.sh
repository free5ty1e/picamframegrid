#!/bin/bash

echo "Installing / enabling camgrid.service and reloading systemctl daemon..."
# sudo service camgrid stop
systemctl --user stop camgrid
cp -vf $HOME/reference/xsessionrc "$HOME/.xsessionrc"
chmod +x /home/pi/.xsessionrc
sudo cp -vf $HOME/reference/xsession.target /etc/systemd/user/
sudo cp -vf $HOME/reference/camgrid.service /etc/systemd/user/
mkdir -vp "$HOME/.camgrid"
cp --verbose --no-clobber $HOME/reference/camgrid.conf "$HOME/.camgrid/"
systemctl --user daemon-reload
systemctl --user enable camgrid
camgridservicestart.sh
