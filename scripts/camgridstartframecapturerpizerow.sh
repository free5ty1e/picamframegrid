#!/bin/bash
. $HOME/.camgrid/camgrid.conf

echo "start frame capture"
STREAM_URL="$1"
STREAM_TITLE="$2"
XOFFSET="$3"
YOFFSET="$4"
STREAM_FPS="$5"

CAPTURE_WIDTH="${CAPTURE_RESOLUTION%x*}"
CAPTURE_HEIGHT="${CAPTURE_RESOLUTION#*x}"

echo "CAPTURE_WIDTH=\"$CAPTURE_WIDTH\""
echo "CAPTURE_HEIGHT=\"$CAPTURE_HEIGHT\""

FIFO_PATH="/dev/shm/fb_$STREAM_TITLE.raw"
echo "Setting up FIFO buffer at $FIFO_PATH..."
rm -f "$FIFO_PATH"
mkfifo "$FIFO_PATH"
chmod 777 "$FIFO_PATH"

echo "parameter 1 should be STREAM_URL and it is $STREAM_URL"
echo "parameter 2 should be STREAM_TITLE and it is $STREAM_TITLE"
echo "parameter 3 should be XOFFSET and it is $XOFFSET"
echo "parameter 4 should be YOFFSET and it is $YOFFSET"
echo "parameter 5 should be STREAM_FPS and it is $STREAM_FPS"
echo "======----->>>Starting RTSP stream (# $i named $STREAM_TITLE) capture of URL $STREAM_URL at $CAPTURE_RESOLUTION $STREAM_FPS FPS to $CAPTURE_LOCATION/$STREAM_TITLE.$CAPTURE_FORMAT..."


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

		# nice -10 \
		# 	ffmpeg -threads 1 -timeout $RTSP_TIMEOUT -err_detect ignore_err \
		# 	-rtsp_transport udp -avioflags direct -fflags nobuffer+discardcorrupt+flush_packets -flags low_delay \
		# 	-use_wallclock_as_timestamps 1 -vsync drop -max_delay 0 -rtbufsize 64K \
		# 	-i "$STREAM_URL" \
		# 	-vf 'setpts=PTS-STARTPTS' -pix_fmt rgb565le -preset ultrafast -an -y -f fbdev \
		# 	-r $STREAM_FPS -fps_mode drop \
		# 	-xoffset $XOFFSET -yoffset $YOFFSET -s $CAPTURE_RESOLUTION \
		# 	/dev/fb0 </dev/null;

		# nice -10 \
		# 	ffmpeg -threads 1 -timeout $RTSP_TIMEOUT -err_detect ignore_err \
		# 	-rtsp_transport udp -avioflags direct -fflags nobuffer+discardcorrupt+flush_packets \
		# 	-flags low_delay -use_wallclock_as_timestamps 1 -vsync drop -max_delay 0 -rtbufsize 64K \
		# 	-i "$STREAM_URL" \
		# 	-vf 'setpts=PTS-STARTPTS' -pix_fmt rgb565le -an -y -f fbdev \
		# 	-r $STREAM_FPS -fps_mode drop \
		# 	-xoffset $XOFFSET -yoffset $YOFFSET -s $CAPTURE_RESOLUTION \
		# 	/dev/fb0 </dev/null;


echo "Launching FFmpeg for $STREAM_TITLE -> $FIFO_PATH..."
nice -10 ffmpeg \
    -threads 1 -timeout $RTSP_TIMEOUT -err_detect ignore_err \
    -rtsp_transport udp -avioflags direct -fflags nobuffer+discardcorrupt+flush_packets \
    -flags low_delay -use_wallclock_as_timestamps 1 -max_delay 0 -rtbufsize 64K \
    -c:v h264_v4l2m2m -extra_hw_frames 3 \
    -i "$STREAM_URL" \
    -fps_mode drop \
    -vf "scale=$CAPTURE_WIDTH:$CAPTURE_HEIGHT,format=rgb565le" \
    -pix_fmt rgb565le -an -y -f rawvideo \
    -r $STREAM_FPS "$FIFO_PATH"

