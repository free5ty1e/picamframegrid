#!/bin/bash
. $HOME/.camgrid/camgrid.conf

FFMPEG_INPUT_PARAMETERS=""
FFMPEG_FILTER_PARAMETERS_A=""
FFMPEG_FILTER_PARAMETERS_B=""

for i in "${!RTSP_STREAM_URLS[@]}"; do 
	STREAM_URL=${RTSP_STREAM_URLS[$i]}
	STREAM_TITLE=${RTSP_STREAM_TITLES[$i]}
	echo "======----->>>Starting RTSP stream (# $i named $STREAM_TITLE) capture of URL $STREAM_URL at $CAPTURE_RESOLUTION $CAPTURE_FPS FPS to $CAPTURE_LOCATION/$STREAM_TITLE.$CAPTURE_FORMAT..."
	
	XVAL=`echo "$i*480" | bc`

	FFMPEG_INPUT_PARAMETERS="$FFMPEG_INPUT_PARAMETERS-i $STREAM_URL "
	FFMPEG_FILTER_PARAMETERS_A="$FFMPEG_FILTER_PARAMETERS_A
	[$i:v] setpts=PTS-STARTPTS, scale=480x270 [video$i]"

	if [ $i > 0 ]; then
 		FFMPEG_FILTER_PARAMETERS_B="$FFMPEG_FILTER_PARAMETERS_B [tmp$i];
 		[tmp$i]"
 	else
 		FFMPEG_FILTER_PARAMETERS_B="$FFMPEG_FILTER_PARAMETERS_B
 		[base]"
	fi

	FFMPEG_FILTER_PARAMETERS_B="$FFMPEG_FILTER_PARAMETERS_B[video1] overlay=shortest=0;x=$XVAL"
	#camgridstartframecapture.sh "$STREAM_URL" "$STREAM_TITLE" &

	# sudo ffmpeg -loglevel fatal -i "$STREAM_URL" -vf fps=fps=$CAPTURE_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION "$CAPTURE_LOCATION/$STREAM_TITLE.jpg" </dev/null &
	#-stimeout $RTSP_TIMEOUT -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 2 -f fifo -fifo_format flv -drop_pkts_on_overflow 1 -attempt_recovery 1 -recover_any_error 1
	export CAPTURE_STREAM_PID=$!
	echo "Waiting a second to stagger the streams..."
	sleep 1
done


ffmpeg -loglevel fatal -threads 1 -stimeout $RTSP_TIMEOUT -analyzeduration 10M -probesize 10M -re $FFMPEG_INPUT_PARAMETERS -filter_complex "
nullsrc=size=1280x1024 [base];
$FFMPEG_FILTER_PARAMETERS_A
$FFMPEG_FILTER_PARAMETERS_B
" -pix_fmt bgra -f fbdev /dev/fb0

# sudo ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -i "$RTSP_STREAM_URL_2" -vf fps=fps=$CAPTURE_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION /ramdisk/rtspstream2.jpg </dev/null &
# export CAPTURE_STREAM_PID_2=$!

