#!/bin/bash
. $HOME/.camgrid/camgrid.conf

for i in "${!RTSP_STREAM_URLS[@]}"; do 
    STREAM_URL=${RTSP_STREAM_URLS[$i]}
    STREAM_TITLE=${RTSP_STREAM_TITLES[$i]}
    STREAM_XOFFSET=${RTSP_STREAM_XOFFSETS[$i]}
    STREAM_YOFFSET=${RTSP_STREAM_YOFFSETS[$i]}
    STREAM_FPS=${RTSP_STREAM_FPS[$i]}

	echo "======----->>>Starting RTSP stream (# $i named $STREAM_TITLE) capture of URL $STREAM_URL at $CAPTURE_RESOLUTION $STREAM_FPS FPS to $CAPTURE_LOCATION/$STREAM_TITLE.$CAPTURE_FORMAT or to location $STREAM_XOFFSET, $STREAM_YOFFSET..."

    camgridstartframecapturerpizerow.sh "$STREAM_URL" "$STREAM_TITLE" "$STREAM_XOFFSET" "$STREAM_YOFFSET" "$STREAM_FPS" &
    
    sleep 1  # Stagger streams slightly
done

# Start the framebuffer writer
$HOME/.camgrid/camgridframebufferwriter.sh &
