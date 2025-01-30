#!/bin/bash
. $HOME/.camgrid/camgrid.conf

echo "start frame capture"
STREAM_URL="$1"
STREAM_TITLE="$2"
XOFFSET="$3"
YOFFSET="$4"
STREAM_FPS="$5"
echo "parameter 1 should be STREAM_URL and it is $STREAM_URL"
echo "parameter 2 should be STREAM_TITLE and it is $STREAM_TITLE"
echo "parameter 3 should be XOFFSET and it is $XOFFSET"
echo "parameter 4 should be YOFFSET and it is $YOFFSET"
echo "parameter 5 should be STREAM_FPS and it is $STREAM_FPS"
echo "======----->>>Starting RTSP stream (# $i named $STREAM_TITLE) capture of URL $STREAM_URL at $CAPTURE_RESOLUTION $STREAM_FPS FPS to $CAPTURE_LOCATION/$STREAM_TITLE.$CAPTURE_FORMAT..."

while true; do 
	if [ "$CAMGRID_METHOD" == "desktop_xfce" ]; then
		nice -10 ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -skip_frame nokey -i "$STREAM_URL" -vf fps=fps=$STREAM_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION "$CAPTURE_LOCATION/$STREAM_TITLE.$CAPTURE_FORMAT" </dev/null; 
	elif [ "$CAMGRID_METHOD" == "direct_to_framebuffer" ]; then
		# nice -10 ffmpeg -loglevel fatal -threads 1 -stimeout $RTSP_TIMEOUT -lowres 0 -skip_loop_filter 1 -skip_frame nokey -ticks_per_frame 2 -flags2 fast -ec favor_inter -idct simpleauto -err_detect ignore_err -strict unofficial -bug autodetect -i "$STREAM_URL" -an -y -filter_complex "mpdecimate, setpts=N/$STREAM_FPS/TB, fps=fps=$STREAM_FPS, scale=$CAPTURE_RESOLUTION" -pix_fmt bgra -update 1 -f fbdev -xoffset $XOFFSET -yoffset $YOFFSET /dev/fb0 </dev/null;
		# nice -10 ffmpeg -threads 1 -timeout $RTSP_TIMEOUT -lowres 0 -skip_loop_filter 1 -skip_frame nokey -flags2 fast -ec favor_inter -idct simpleauto -err_detect ignore_err -strict unofficial -bug autodetect -i "$STREAM_URL" -an -y -filter_complex "mpdecimate, setpts=N/$STREAM_FPS/TB, fps=fps=$STREAM_FPS, scale=$CAPTURE_RESOLUTION" -pix_fmt rgb565le -update 1 -f fbdev -xoffset $XOFFSET -yoffset $YOFFSET -c copy /dev/fb0 </dev/null;
		# nice -10 ffmpeg -threads 1 -timeout $RTSP_TIMEOUT -err_detect ignore_err -i "$STREAM_URL" -pix_fmt rgb565le -preset ultrafast -c:a copy -an -y -f fbdev -xoffset $XOFFSET -yoffset $YOFFSET -s $CAPTURE_RESOLUTION /dev/fb0 </dev/null;
		
		#nice -10 ffmpeg -threads 1 -timeout $RTSP_TIMEOUT -err_detect ignore_err -fflags nobuffer -flags low_delay -i "$STREAM_URL" -vf 'setpts=PTS-STARTPTS' -pix_fmt rgb565le -preset ultrafast -c:a copy -an -y -f fbdev -xoffset $XOFFSET -yoffset $YOFFSET -s $CAPTURE_RESOLUTION /dev/fb0 </dev/null;
		# -loglevel fatal

		# nice -10 \
		# 	ffmpeg -threads 1 -timeout $RTSP_TIMEOUT -err_detect ignore_err -fflags nobuffer -flags low_delay \
		# 	-i "$STREAM_URL" \
		# 	-vf 'setpts=PTS-STARTPTS' -pix_fmt rgb565le -preset ultrafast -an -y -f fbdev \
		# 	-r $STREAM_FPS \
		# 	-xoffset $XOFFSET -yoffset $YOFFSET -s $CAPTURE_RESOLUTION \
		# 	/dev/fb0 </dev/null;

		# nice -10 \
		# 	ffmpeg -threads 1 -timeout $RTSP_TIMEOUT -err_detect ignore_err \
		# 	-rtsp_transport udp -avioflags direct -fflags discardcorrupt+flush_packets -flags low_delay \
		# 	-use_wallclock_as_timestamps 1 \
		# 	-i "$STREAM_URL" \
		# 	-vf 'setpts=PTS-STARTPTS' -pix_fmt rgb565le -preset ultrafast -an -y -f fbdev \
		# 	-r $STREAM_FPS -fps_mode drop \
		# 	-xoffset $XOFFSET -yoffset $YOFFSET -s $CAPTURE_RESOLUTION \
		# 	/dev/fb0 </dev/null;

		nice -10 \
			ffmpeg -threads 1 -timeout $RTSP_TIMEOUT -err_detect ignore_err \
			-rtsp_transport udp -avioflags direct -fflags nobuffer+discardcorrupt+flush_packets -flags low_delay \
			-use_wallclock_as_timestamps 1 -vsync drop -max_delay 0 -rtbufsize 64K \
			-re \ # realtime
			-i "$STREAM_URL" \
			-vf 'setpts=PTS-STARTPTS' -pix_fmt rgb565le -preset ultrafast -an -y -f fbdev \
			-r $STREAM_FPS -fps_mode drop \
			-xoffset $XOFFSET -yoffset $YOFFSET -s $CAPTURE_RESOLUTION \
			/dev/fb0 </dev/null;


		# -loglevel fatal


		# -c:v libx264 -ticks_per_frame 2 -filter_complex "mpdecimate, setpts=N/$STREAM_FPS/TB, fps=fps=$STREAM_FPS, scale=$CAPTURE_RESOLUTION" -lowres 0 -skip_loop_filter 1 -skip_frame nokey -strict unofficial -bug autodetect -ec favor_inter -idct simpleauto -pix_fmt rgb565le -update 1
		# -c copy -flags2 fast
	fi 

done

#Auto-restart loop:
# until $cmd ; do
#         echo "restarting ffmpeg command for $STREAM_TITLE..."
#         sleep 2
# done

# sudo ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -i "$RTSP_STREAM_URL_2" -vf fps=fps=$STREAM_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION /ramdisk/rtspstream2.jpg </dev/null &
# export CAPTURE_STREAM_PID_2=$!
