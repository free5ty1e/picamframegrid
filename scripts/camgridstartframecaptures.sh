#!/bin/bash
. $HOME/.camgrid/camgrid.conf

FFMPEG_INPUT_PARAMETERS=""
FFMPEG_FILTER_PARAMETERS_A=""
FFMPEG_FILTER_PARAMETERS_B=""

for i in "${!RTSP_STREAM_URLS[@]}"; do 
	STREAM_URL=${RTSP_STREAM_URLS[$i]}
	STREAM_TITLE=${RTSP_STREAM_TITLES[$i]}
	STREAM_XOFFSET=${RTSP_STREAM_XOFFSETS[$i]}
	STREAM_YOFFSET=${RTSP_STREAM_YOFFSETS[$i]}
	STREAM_FPS=${RTSP_STREAM_FPS[$i]}


	echo "======----->>>Starting RTSP stream (# $i named $STREAM_TITLE) capture of URL $STREAM_URL at $CAPTURE_RESOLUTION $STREAM_FPS FPS to $CAPTURE_LOCATION/$STREAM_TITLE.$CAPTURE_FORMAT or to location $STREAM_XOFFSET, $STREAM_YOFFSET..."
	
# 	XVAL=`echo "$i*480" | bc`

# 	FFMPEG_INPUT_PARAMETERS="$FFMPEG_INPUT_PARAMETERS-i $STREAM_URL "
# 	FFMPEG_FILTER_PARAMETERS_A="$FFMPEG_FILTER_PARAMETERS_A
# [$i:v] setpts=PTS-STARTPTS, scale=480x270 [video$i];"

# 	if [ $i > 0 ]; then
#  		FFMPEG_FILTER_PARAMETERS_B="$FFMPEG_FILTER_PARAMETERS_B [tmp$i];
# [tmp$i]"
#  	else
#  		FFMPEG_FILTER_PARAMETERS_B="$FFMPEG_FILTER_PARAMETERS_B[base]"
# 	fi

# 	FFMPEG_FILTER_PARAMETERS_B="$FFMPEG_FILTER_PARAMETERS_B[video$i] overlay=shortest=0:x=$XVAL"

	camgridstartframecapture.sh "$STREAM_URL" "$STREAM_TITLE" "$STREAM_XOFFSET" "$STREAM_YOFFSET" "$STREAM_FPS" &

	# sudo ffmpeg -loglevel fatal -i "$STREAM_URL" -vf fps=fps=$STREAM_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION "$CAPTURE_LOCATION/$STREAM_TITLE.jpg" </dev/null &
	#-stimeout $RTSP_TIMEOUT -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 2 -f fifo -fifo_format flv -drop_pkts_on_overflow 1 -attempt_recovery 1 -recover_any_error 1
	export CAPTURE_STREAM_PID=$!
	echo "Waiting a second to stagger the streams..."
	sleep 1
done


# ffmpeg -loglevel fatal -threads 1 -stimeout $RTSP_TIMEOUT -analyzeduration 10M -probesize 10M -re $FFMPEG_INPUT_PARAMETERS -filter_complex "\"
# nullsrc=size=1280x1024 [base];
# $FFMPEG_FILTER_PARAMETERS_A
# $FFMPEG_FILTER_PARAMETERS_B
# \"" -an -pix_fmt bgra -f fbdev /dev/fb0

# sudo ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -i "$RTSP_STREAM_URL_2" -vf fps=fps=$STREAM_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION /ramdisk/rtspstream2.jpg </dev/null &
# export CAPTURE_STREAM_PID_2=$!




# ffmpeg -analyzeduration 10M -probesize 10M -re -i rtsp://sphene:mp3sheet@192.168.100.139/live -i rtsp://rupee:mp3sheet@192.168.100.142/live -update 1 -an -y -s 640x480 -filter_complex "fps=fps=1/5; nullsrc=size=1024x768 [base]; [0:v] setpts=PTS-STARTPTS, scale=640x480 [video0]; [1:v] setpts=PTS-STARTPTS, scale=640x480 [video1]; [base][video0] overlay=shortest=1:x=0 [tmp1]; [tmp1][video1] overlay=shortest=1:x=480" -pix_fmt bgra -f fbdev /dev/fb0

# ffmpeg -analyzeduration 10M -probesize 10M -re -i rtsp://sphene:mp3sheet@192.168.100.139/live -i rtsp://rupee:mp3sheet@192.168.100.142/live -update 1 -an -y -filter_complex "fps=fps=1/5; nullsrc=size=1280x1024 [base]; [0:v] setpts=PTS-STARTPTS, scale=640x480 [video0]; [1:v] setpts=PTS-STARTPTS, scale=640x480 [video1]; [base][video0] overlay=shortest=1:x=0 [tmp1]; [tmp1][video1] overlay=shortest=1:x=480" /ramdisk/camgrid_c.tiff

# ffmpeg -analyzeduration 10M -probesize 10M -re -i rtsp://sphene:mp3sheet@192.168.100.139/live -i rtsp://rupee:mp3sheet@192.168.100.142/live -an -y -filter_complex "fps=fps=1/5; nullsrc=size=1280x1024 [base]; [0:v] setpts=PTS-STARTPTS, scale=640x480 [video0]; [1:v] setpts=PTS-STARTPTS, scale=640x480 [video1]; [base][video0] overlay=shortest=0:x=0 [tmp1]; [tmp1][video1] overlay=shortest=0:x=640" /ramdisk/camgrid_c.tiff

# ffmpeg -analyzeduration 10M -probesize 10M -re -i rtsp://sphene:mp3sheet@192.168.100.139/live -i rtsp://rupee:mp3sheet@192.168.100.142/live -an -y -filter_complex "nullsrc=size=1280x1024 [base]; [0:v] setpts=PTS-STARTPTS, fps=fps=1/5, scale=640x480 [video0]; [1:v] setpts=PTS-STARTPTS, fps=fps=1/5, scale=640x480 [video1]; [base][video0] overlay=shortest=1 [tmp1]; [tmp1][video1] overlay=shortest=1:x=640" /ramdisk/camgrid_c.tiff

# ffmpeg -analyzeduration 10M -probesize 10M -re -i rtsp://sphene:mp3sheet@192.168.100.139/live -i rtsp://rupee:mp3sheet@192.168.100.142/live -an -y -filter_complex "nullsrc=size=1280x1024 [base]; [0:v] setpts=PTS-STARTPTS, fps=fps=1/5, scale=640x480 [video0]; [1:v] setpts=PTS-STARTPTS, fps=fps=1/5, scale=640x480 [video1]; [base][video0] overlay=shortest=1 [tmp1]; [tmp1][video1] overlay=shortest=1:x=640" -pix_fmt bgra -update 1 -f fbdev /dev/fb0


#ffmpeg -skip_frame nokey -i rtsp://sphene:mp3sheet@192.168.100.139/live -an -y -filter_complex "setpts=PTS-STARTPTS, fps=fps=1/5, scale=640x480" -pix_fmt bgra -update 1 -f fbdev /dev/fb0
#ffmpeg -skip_frame nokey -i rtsp://rupee:mp3sheet@192.168.100.142/live -an -y -filter_complex "setpts=PTS-STARTPTS, fps=fps=1/5, scale=640x480" -pix_fmt bgra -update 1 -f fbdev -xoffset 640 /dev/fb0

#ffmpeg -loglevel fatal -lowres 2 -skip_loop_filter 1 -skip_frame nokey -ticks_per_frame 2 -i rtsp://sphene:mp3sheet@192.168.100.139/live -an -y -filter_complex "setpts=PTS-STARTPTS, fps=fps=2, scale=640x480" -pix_fmt bgra -update 1 -f fbdev /dev/fb0

#ffmpeg -lowres 2 -skip_loop_filter 1 -skip_frame nokey -ticks_per_frame 2 -flags2 fast -ec favor_inter -i rtsp://sphene:mp3sheet@192.168.100.139/live -an -y -filter_complex "setpts=PTS-STARTPTS, fps=fps=2, scale=640x480" -pix_fmt bgra -update 1 -f fbdev /dev/fb0

#ffmpeg -lowres 2 -skip_loop_filter 1 -skip_frame nokey -ticks_per_frame 2 -flags2 fast -ec favor_inter -idct simpleauto -i rtsp://sphene:mp3sheet@192.168.100.139/live -an -y -filter_complex "setpts=PTS-STARTPTS, fps=fps=2, scale=640x480" -pix_fmt bgra -update 1 -f fbdev /dev/fb0

#ffmpeg -lowres 0 -skip_loop_filter 1 -skip_frame nokey -ticks_per_frame 2 -flags2 fast -ec favor_inter -idct simpleauto -err_detect ignore_err -i rtsp://sphene:mp3sheet@192.168.100.139/live -an -y -filter_complex "setpts=PTS-STARTPTS, fps=fps=2, scale=640x480" -pix_fmt bgra -update 1 -f fbdev /dev/fb0

#ffmpeg -lowres 0 -skip_loop_filter 1 -skip_frame nokey -ticks_per_frame 2 -flags2 fast -ec favor_inter -idct simpleauto -err_detect ignore_err -strict unofficial -bug autodetect -i rtsp://sphene:mp3sheet@192.168.100.139/live -an -y -filter_complex "setpts=PTS-STARTPTS, fps=fps=2, scale=640x480" -pix_fmt bgra -update 1 -f fbdev /dev/fb0




