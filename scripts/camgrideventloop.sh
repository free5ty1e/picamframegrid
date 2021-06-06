#!/bin/bash
. $HOME/.camgrid/camgrid.conf

echo "User is `id -nu`, should be pi for this to work..."
# if [[ `id -nu` != "pi" ]];then
#    echo "Not pi user, exiting.."
#    exit 1
# fi
CAMGRIDFILEA="/$CAPTURE_LOCATION/camgrid_a.$CAPTURE_FORMAT"
CAMGRIDFILEB="/$CAPTURE_LOCATION/camgrid_b.$CAPTURE_FORMAT"
echo "Camgrid filenames are $CAMGRIDFILEA and $CAMGRIDFILEB"

camgridgenerateframe.sh "$CAMGRIDFILEA"
camgridsetdesktopbackground.sh "$CAMGRIDFILEA"
screensaverdisable.sh
export WHICHCAMGRID=a

##OLD LOOP:
# while [ 1 ]
# # for i in {0..10}
# do
# 	# echo "Generating frame $i of 10..."
# 	# camgridframe.sh
# 	sleep $SECONDS_BETWEEN_DISPLAY_FRAMES
# 	camgridgenerateframe.sh "$CAMGRIDFILEB"
# 	camgridsetdesktopbackground.sh "$CAMGRIDFILEB"
# 	sleep $SECONDS_BETWEEN_DISPLAY_FRAMES
# 	camgridgenerateframe.sh "$CAMGRIDFILEA"
# 	camgridsetdesktopbackground.sh "$CAMGRIDFILEA"
# 	screensaverdisable.sh
# 	# camgriddisplayframe.sh
#    # sudo killall fim
# done

if [ "$CAMGRID_METHOD" == "desktop_xfce" ]; then
	##NEW LOOP:
	inotifywait --event close_write,moved_to,create --monitor "$CAPTURE_LOCATION" |
	while read -r directory events filename; do
		for i in "${!RTSP_STREAM_TITLES[@]}"; do 
			STREAM_TITLE=${RTSP_STREAM_TITLES[$i]}
			if [ "$filename" == "$STREAM_TITLE.$CAPTURE_FORMAT" ]; then
				echo "$filename change detected, WHICHCAMGRID is currently $WHICHCAMGRID"
				if [ "$WHICHCAMGRID" == "a" ]; then
					echo "WHICHCAMGRID is currently set A, toggling to B..."
					camgridgenerateframe.sh "$CAMGRIDFILEB"
					camgridsetdesktopbackground.sh "$CAMGRIDFILEB"
					export WHICHCAMGRID=b
				else
					echo "WHICHCAMGRID is currently set B, toggling to A..."
					camgridgenerateframe.sh "$CAMGRIDFILEA"
					camgridsetdesktopbackground.sh "$CAMGRIDFILEA"
					screensaverdisable.sh
					export WHICHCAMGRID=a
				fi
	  		fi
		done
	done
else
	while true; do
		sleep 30
	done
fi
