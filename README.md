# picamframegrid
A simple multi-webcam framegrab grid display service for Wyze RTSP or other HD-only cam streams that runs reliably on a Raspberry Pi 3b

Current implementation:
* Is a service that utilizes multiple (give it a list) ffmpeg RTSP streams from Wyze cams (1080p only, no low-res streams are available via RTSP as far as I know so this breaks all other Pi cam grid repos that I am aware of - such as `camplayer` https://github.com/raspicamplayer/camplayer and which utilizes `omxplayer` and also two custom `vlc` configs, mosaic implementation and multi-window - as soon as it tries to display two of my Wyze cams simultaneously it blanks out or flashes horribly in a seizure-inducing manner).
* These `ffmpeg` instances write their frames to the `/ramdisk` folder, which is currently a `30MB` RAM drive set up with the following `/etc/fstab` entry:
```
cambuffer /ramdisk tmpfs size=30M,noatime,nodev,nosuid,noexec,nodiratime 0 0
```
* The frames are by default captured in `.tiff` format as it seemed to be the most reliable and fastest so far but can easily choose `.jpg` or `.bmp`.  The format you choose in the conf file (`/home/pi/.picamframegrid/picamframegrid.conf`) will be also utilized for the grid image format.
* Capture size for each frame is by default `640x480` but you can change it in the conf file.
* `gpu_mem=64` specifies the size of the GPU memory I am allocating in `/boot/config.txt`
* I've disabled the swapfile entirely with the following commands:
```
sudo dphys-swapfile swapoff && sudo dphys-swapfile uninstall && sudo update-rc.d dphys-swapfile remove && sudo systemctl disable dphys-swapfile
```
* `inotifywait` is utilized in another thread to watch for changes to the framegrab files, which triggers the frames to be assembled 
* frames are being assembled via the `imagemagick` `montage` command in an a/b file pattern to `/ramdisk` and then these a/b images are being set as the `xfce` desktop background for a seamless frame update experience
* The system auto logs into the desktop and starts the service, triggered by a custom `xsession.trigger` that I added to kick off the service once the desktop session has started - can just connect up to a monitor and watch your cameras after booting it up anywhere with network.
* Can use the standard `/boot/wpa_supplicant.conf` to tell a Pi with wifi to auto connect to your network, here's an example article on how to do this: https://www.raspberrypi-spy.co.uk/2017/04/manually-setting-up-pi-wifi-using-wpa_supplicant-conf/


## Performance

The current implementation:
![2021-05-29-214646_1280x1024_scrot](https://user-images.githubusercontent.com/5496151/120084426-e1b6c600-c084-11eb-95e6-3c01abccca6e.png)
* I am displaying 2 of my Wyze cams in a side-by-side grid
* Handles 4 seconds / frame without thermal throttling on a Raspberry Pi 3b with passive cooling / stock clock
* Thermal throttling occurs at anything faster than 3 seconds / frame in this configuration, but it still seems to work even at 1fps (fastest I've tried so far)



I will post more info about my findings on how reliable / performant this is on various Raspberry Pi's as I get a chance to test them.  I even have a Pi Zero W here that should be able to handle this task in some capacity.



## Installation
To install the `picamframegrid` service, you can copypasta the following line into your SSH terminal session:
```
git clone https://github.com/free5ty1e/picamframegrid.git && pushd picamframegrid && ./pcfginstall.sh && popd
```

This will only work on an `xfce` desktop right now so if you have another installed it may not work.  YMMV, and feel free to submit improvements - like other desktops support with a setting in the `conf` file, or perhaps without a desktop...



## Coming Soon:
* I will be extracting the `camgrid` functionality from my `debianusbfileserver` repo as it has grown to the point of needing its own repo, methinks
* Pre-built Raspberry Pi image, just edit the `/home/pi/.camgrid/camgrid.conf` file to set it up and then `camgridrestartservice.sh`
* Better documentation, I guess
