#!/bin/bash

pushd ~
cat /dev/fb0 > screenshot.raw
# iraw2png 640 480 < screenshot.raw > screenshot.png
rm screenshot.prev.png
mv screenshot.png screenshot.prev.png
ffmpeg -vcodec rawvideo -f rawvideo -pix_fmt rgb565 -s 640x480 -i screenshot.raw -vframes 1 screenshot.png
rm screenshot.raw
echo "Screenshot of framebuffer should now be saved as ~/screenshot.png"
popd
