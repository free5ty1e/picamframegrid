#!/bin/bash
. $HOME/.camgrid/camgrid.conf

echo "start frame capture"
STREAM_URL="$1"
STREAM_TITLE="$2"
echo "parameter 1 should be STREAM_URL and it is $STREAM_URL"
echo "parameter 2 should be STREAM_TITLE and it is $STREAM_TITLE"
echo "======----->>>Starting RTSP stream (# $i named $STREAM_TITLE) capture of URL $STREAM_URL at $CAPTURE_RESOLUTION $CAPTURE_FPS FPS to $CAPTURE_LOCATION/$STREAM_TITLE.$CAPTURE_FORMAT..."

while true; do 
	ffmpeg -loglevel fatal -threads 1 -timeout -timeout $IO_TIMEOUT -stimeout $RTSP_TIMEOUT -i "$STREAM_URL" -vf fps=fps=$CAPTURE_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION "$CAPTURE_LOCATION/$STREAM_TITLE.$CAPTURE_FORMAT" </dev/null; 
done

#Auto-restart loop:
# until $cmd ; do
#         echo "restarting ffmpeg command for $STREAM_TITLE..."
#         sleep 2
# done

# sudo ffmpeg -loglevel fatal -stimeout $RTSP_TIMEOUT -i "$RTSP_STREAM_URL_2" -vf fps=fps=$CAPTURE_FPS -update 1 -an -y -s $CAPTURE_RESOLUTION /ramdisk/rtspstream2.jpg </dev/null &
# export CAPTURE_STREAM_PID_2=$!
