#!/bin/bash

echo "Installing / enabling camgrid.service and reloading systemctl daemon..."
camgridservicestop.sh
cp -vf "$HOME/reference/xsessionrc" "$HOME/.xsessionrc"
chmod +x "$HOME/.xsessionrc"
sudo cp -vf "$HOME/reference/xsession.target" "/etc/systemd/user/"
sudo cp -vf "$HOME/reference/camgrid.service" "/etc/systemd/user/"
mkdir -vp "$HOME/.camgrid"
cp --verbose --no-clobber "$HOME/reference/camgrid.conf" "$HOME/.camgrid/"
systemctl --user daemon-reload
systemctl --user enable camgrid
camgridservicestart.sh
