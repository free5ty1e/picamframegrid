#!/bin/bash
. $HOME/.camgrid/camgrid.conf

for i in "${!RTSP_STREAM_URLS[@]}"; do 
	STREAM_URL=${RTSP_STREAM_URLS[$i]}
	STREAM_TITLE=${RTSP_STREAM_TITLES[$i]}
	echo "======----->>>Starting RTSP stream (# $i named $STREAM_TITLE) capture of URL $STREAM_URL at $CAPTURE_RESOLUTION $CAPTURE_FPS FPS to $CAPTURE_LOCATION/$STREAM_TITLE.$CAPTURE_FORMAT..."
	camgridstartframecapture.sh "$STREAM_URL" "$STREAM_TITLE" &
	# sudo ffmpeg -loglevel fatal -i "$STREAM_URL" -vf fps=fps=$CAPTURE_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION "$CAPTURE_LOCATION/$STREAM_TITLE.jpg" </dev/null &
	#-stimeout $RTSP_TIMEOUT -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 2 -f fifo -fifo_format flv -drop_pkts_on_overflow 1 -attempt_recovery 1 -recover_any_error 1
	export CAPTURE_STREAM_PID=$!
done

# sudo ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -i "$RTSP_STREAM_URL_2" -vf fps=fps=$CAPTURE_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION /ramdisk/rtspstream2.jpg </dev/null &
# export CAPTURE_STREAM_PID_2=$!

