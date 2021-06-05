#!/bin/bash

echo "Installing / enabling camgrid.service and reloading systemctl daemon..."
camgridservicestop.sh
sudo cp -vf "$HOME/picamframegrid/reference/camgrid.d2fb.service" "/etc/systemd/user/camgrid.service"
mkdir -vp "$HOME/.camgrid"
cp --verbose --no-clobber "$HOME/picamframegrid/reference/camgrid.conf" "$HOME/.camgrid/"
systemctl --user daemon-reload
systemctl --user enable camgrid
camgridservicestart.sh
