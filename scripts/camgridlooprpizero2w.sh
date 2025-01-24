#!/bin/bash
. $HOME/.camgrid/camgrid.conf

echo "User is `id -nu`, should be pi for this to work..."
# if [[ `id -nu` != "pi" ]];then
#    echo "Not pi user, exiting.."
#    exit 1
# fi

camgridstopframecaptures.sh
camgridstartframecapturesrpizero2w.sh
sleep 10

camgrideventloop.sh
