#!/bin/bash

message="Initiating a quick-update..."
echo "$message"
cowsay -f eyes "$message"

pushd "$HOME/picamframegrid"
git fetch
headsha=$(git rev-parse HEAD)
upstreamsha=$(git rev-parse @{u})
if [ "$headsha" != "$upstreamsha" ]
then
    echo "Changes detected upstream!  Updating..."
    git pull
    scripts/camgridinstall.sh
else
    echo "No changes exist upstream, no need to perform any update operations for this repo!"
fi
popd
