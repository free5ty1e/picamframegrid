#!/bin/bash
. $HOME/.camgrid/camgrid.conf

# Determine the highest FPS to set the update rate
MAX_FPS=1  # Default to 1 FPS in case of errors
for fps in "${RTSP_STREAM_FPS[@]}"; do
    if (( fps > MAX_FPS )); then
        MAX_FPS=$fps
    fi
done

# Calculate sleep delay
FRAME_DELAY=$(awk "BEGIN {print 1/$MAX_FPS}")

# declare -a FIFO_PATHS
# for i in "${!RTSP_STREAM_TITLES[@]}"; do 
#     FIFO_PATHS[$i]="/dev/shm/fb_${RTSP_STREAM_TITLES[$i]}.raw"
# done

echo "Starting framebuffer writer... Max FPS: $MAX_FPS, Frame delay: $FRAME_DELAY seconds"

# while true; do
#     for i in "${!FIFO_PATHS[@]}"; do
#         if [[ -p "${FIFO_PATHS[$i]}" ]]; then
#             dd if="${FIFO_PATHS[$i]}" of=/dev/fb0 bs=153600 count=1 seek=$((RTSP_STREAM_YOFFSETS[i] * 640 + RTSP_STREAM_XOFFSETS[i])) status=none
#         fi
#     done
#     sleep "$FRAME_DELAY"
# done

PIXEL_SIZE=2           # RGB565 format uses 2 bytes per pixel
FRAME_SIZE=$((320 * 240 * PIXEL_SIZE))  # 320x240 frame in RGB565

# Ensure FIFOs exist
for i in "${!RTSP_STREAM_TITLES[@]}"; do
    FIFO_PATH="/dev/shm/fb_${RTSP_STREAM_TITLES[$i]}.raw"

    if [[ ! -p "$FIFO_PATH" ]]; then
        echo "Creating missing FIFO: $FIFO_PATH"
        rm -f "$FIFO_PATH"
        mkfifo "$FIFO_PATH"
        chmod 777 "$FIFO_PATH"
    fi
done

echo "Starting framebuffer writer..."

while true; do
    for i in "${!RTSP_STREAM_TITLES[@]}"; do
        FIFO_PATH="/dev/shm/fb_${RTSP_STREAM_TITLES[$i]}.raw"
        XOFFSET=${RTSP_STREAM_XOFFSETS[$i]}
        YOFFSET=${RTSP_STREAM_YOFFSETS[$i]}

        # Calculate framebuffer byte offset
        SEEK_POS=$(( (YOFFSET * FRAMEBUFFER_WIDTH + XOFFSET) * PIXEL_SIZE ))

        if [[ -p "$FIFO_PATH" ]]; then
            # Ensure correct frame size is read to avoid framebuffer corruption
            timeout 1 head -c "$FRAME_SIZE" "$FIFO_PATH" | dd of=/dev/fb0 bs=1 seek=$SEEK_POS conv=notrunc status=none iflag=nonblock
        fi
    done
    
    sleep "$FRAME_DELAY"
done
