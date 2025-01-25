# picamframegrid
A simple multi-webcam framegrab grid display service for Wyze RTSP with wz-mini-hacks or other RTSP cam streams that runs reliably on a Raspberry Pi Zero 2 w with 3 360p RTSP streams at roughly 10fps (all I've tested with so far).  

![My Wyze cams](https://github.com/user-attachments/assets/a4f95508-3b13-4a43-9fa2-635f4885684c)
![top](https://github.com/user-attachments/assets/d3d2baaf-0b50-457b-ad76-83acd0b40662)

The RTSP streams are minimally transcoded to be directly displayable via the framebuffer.  This does not record streams, only does a quick and dirty grid display on the connected HDMI display.


## Installation
To install the `picamframegrid` service, you can copypasta the following line into your SSH terminal session:
```
git clone https://github.com/free5ty1e/picamframegrid.git && pushd picamframegrid && ./scripts/camgridinstall.sh && popd
```

This only requires a "lite" raspbian OS, no desktop / LXDE mode needed.  


## Current implementation
* Is a service that utilizes multiple (give it a list) ffmpeg RTSP streams from Wyze cams.
* (DIRECT TO FRAMEBUFFER METHOD - NEW) These `ffmpeg` instances write their frames directly to the provided position on the screen / in the framebuffer (positions are provided in lists in the conf file along with the stream URLs in 2 additional arrays), which displays directly without an intermediate file or a need to compile multiple framegrabs into a single image.
* (DESKTOP METHOD - OLD) These `ffmpeg` instances write their frames to the `/ramdisk` folder, which is currently a `30MB` RAM drive set up with the following `/etc/fstab` entry:
```
cambuffer /ramdisk tmpfs size=30M,noatime,nodev,nosuid,noexec,nodiratime 0 0
```
* (DESKTOP METHOD - OLD) The frames are by default captured in `.tiff` format as it seemed to be the most reliable and fastest so far but can easily choose `.jpg` or `.bmp`.  The format you choose in the conf file (`/home/pi/.camgrid/camgrid.conf`) will be also utilized for the grid image format.
* Capture size for each frame is by default `640x480` but you can change it in the conf file.
* `gpu_mem=64` specifies the size of the GPU memory I am allocating in `/boot/config.txt`
* I've disabled the swapfile entirely with the following commands:
```
sudo dphys-swapfile swapoff && sudo dphys-swapfile uninstall && sudo update-rc.d dphys-swapfile remove && sudo systemctl disable dphys-swapfile
```
* I've installed `log2ram` ( https://github.com/azlux/log2ram ) to really minimize SD card write cycles, and adjusted the log size to `30MB` and enabled the `ram compression with the following setting in `/etc/log2ram.conf`:
```
SIZE=30M
# **************** Zram backing conf  *************************************************

# ZL2R Zram Log 2 Ram enables a zram drive when ZL2R=true ZL2R=false is mem only tmpfs
ZL2R=true
# COMP_ALG this is any compression algorithm listed in /proc/crypto
# lz4 is fastest with lightest load but deflate (zlib) and Zstandard (zstd) give far better compression ratios
# lzo is very close to lz4 and may with some binaries have better optimisation
# COMP_ALG=lz4 for speed or Zstd for compression, lzo or zlib if optimisation or availabilty is a problem
COMP_ALG=Zstd
# LOG_DISK_SIZE is the uncompressed disk size. Note zram uses about 0.1% of the size of the disk when not in use
# LOG_DISK_SIZE is expected compression ratio of alg chosen multiplied by log SIZE
# lzo/lz4=2.1:1 compression ratio zlib=2.7:1 zstandard=2.9:1
# Really a guestimate of a bit bigger than compression ratio whilst minimising 0.1% mem usage of disk size
LOG_DISK_SIZE=40M
```

(OLD info for desktop mode)
* `inotifywait` is utilized in another thread to watch for changes to the framegrab files, which triggers the frames to be assembled 
* frames are being assembled via the `imagemagick` `montage` command in an a/b file pattern to `/ramdisk` and then these a/b images are being set as the `xfce` desktop background for a seamless frame update experience
* The system auto logs into the desktop and starts the service, triggered by a custom `xsession.trigger` that I added to kick off the service once the desktop session has started - can just connect up to a monitor and watch your cameras after booting it up anywhere with network.
* Can use the standard `/boot/wpa_supplicant.conf` to tell a Pi with wifi to auto connect to your network, here's an example article on how to do this: https://www.raspberrypi-spy.co.uk/2017/04/manually-setting-up-pi-wifi-using-wpa_supplicant-conf/


## Performance

The `direct_to_framebuffer` method (NEW): 
![My Wyze cams](https://github.com/user-attachments/assets/a4f95508-3b13-4a43-9fa2-635f4885684c)
![top](https://github.com/user-attachments/assets/d3d2baaf-0b50-457b-ad76-83acd0b40662)

* I am displaying 3 of my Wyze cams in a 2x2 configuration, top-left / top-right / bottom-left / bottom-right of the screen (positions and resolution of each frame configurable in the conf file)
* * Handles 10fps each


The `desktop_xfce` method (OLD, was before I added option to only process non-keyframes):
![2021-05-29-214646_1280x1024_scrot](https://user-images.githubusercontent.com/5496151/120084426-e1b6c600-c084-11eb-95e6-3c01abccca6e.png)
* I am displaying 2 of my Wyze cams in a side-by-side grid
* Handles 4 seconds / frame without thermal throttling on a Raspberry Pi 3b with passive cooling / stock clock with ambient room temperature (~70*F)
* Thermal throttling occurs at anything faster than 3 seconds / frame in this configuration, but it still seems to work even at 1fps (fastest I've tried so far)



I will post more info about my findings on how reliable / performant this is on various Raspberry Pi's as I get a chance to test them.  I even have a Pi Zero W here that should be able to handle this task in some capacity.

## Posted on Facebook and Instagram
https://www.facebook.com/plugins/post.php?href=https%3A%2F%2Fwww.facebook.com%2Fchristopher.paiano.5%2Fposts%2F10157674178661879
https://www.instagram.com/p/CPwwF_SMJ89/

## Notes about the old desktop background method:
If desired, you can install the xfce desktop with the `camgridinstallxfce.sh` script, which will prompt you to also set your desktop to auto login at the end via the `raspi-config` command.  This script will also set up the trigger needed to auto start the camgrid service once the xwindow session has started.  You don't need any of this if you just use the default `direct_to_framebuffer` method instead.


## Coming Soon:
* Pre-built Raspberry Pi image, just edit the `/home/pi/.camgrid/camgrid.conf` file to set it up and then `camgridrestartservice.sh`
* Better documentation, I guess
* Testing various potential improvements such as: 
*   attempting to optimize ffmpeg settings to use less memory / cpu
*   trying various frame capture sizes and montage arrangements
*   Anything else people may suggest
