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

PIXEL_SIZE=2           # RGB565 uses 2 bytes per pixel

# Create FIFOs if they don't exist
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

# Continuous loop to read frames and write to framebuffer
while true; do
    for i in "${!RTSP_STREAM_TITLES[@]}"; do
        FIFO_PATH="/dev/shm/fb_${RTSP_STREAM_TITLES[$i]}.raw"
        XOFFSET=${RTSP_STREAM_XOFFSETS[$i]}
        YOFFSET=${RTSP_STREAM_YOFFSETS[$i]}
        
        # Calculate the seek position in bytes
        SEEK_POS=$(( (YOFFSET * FRAMEBUFFER_WIDTH + XOFFSET) * PIXEL_SIZE ))

        if [[ -p "$FIFO_PATH" ]]; then
            # Read from FIFO and write to framebuffer at correct position
            timeout 1 cat "$FIFO_PATH" | dd of=/dev/fb0 bs=1 seek=$SEEK_POS conv=notrunc status=none iflag=nonblock
        fi
    done
    sleep "$FRAME_DELAY"
done
