#!/bin/bash

pushd ~
cat /dev/fb0 > screen.raw
iraw2png 640 480 < screen.raw > screen.png
rm screen.raw
popd
