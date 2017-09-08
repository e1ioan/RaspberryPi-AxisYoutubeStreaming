#!/bin/bash

#https://github.com/prasmussen/gdrive

#directory containing gdrive executable
GDRIVEPATH="/home/pi/gdrive/"
#main directory on google drive
GDRIVECONT="recordings"
#dir with videos
VIDEODIR="/media/usb/"

while true
do
    DATEDIR=$(date +%Y-%m-%d -d "2 hour ago")
    SEARCHF=$(date +%Y-%m-%d_%H -d "2 hour ago")
    LISTA=$(ls "$VIDEODIR"video-"$SEARCHF"*.mp4 2>/dev/null)
    FILE=""

    GDRIVEDIR=$("$GDRIVEPATH"gdrive list --query "mimeType contains 'folder' and name ='${GDRIVECONT}' " 2>/dev/null| grep ${GDRIVECONT} | head -n 1 | awk '{print $1}')
    GDRIVEUPL=""
    if [ "${GDRIVEDIR}" != "" ]; then
        GDRIVEUPL=$("$GDRIVEPATH"gdrive list --query "mimeType contains 'folder' and '${GDRIVEDIR}' in parents and name ='${DATEDIR}'"  2>/dev/null| grep $DATEDIR | head -n 1 | awk '{print $1}')
        if [ "${GDRIVEUPL}" = "" ]; then
			"$GDRIVEPATH"gdrive mkdir --parent ${GDRIVEDIR} ${DATEDIR} &>/dev/null
			sleep 5
			GDRIVEUPL=$("$GDRIVEPATH"gdrive list --query "mimeType contains 'folder' and '${GDRIVEDIR}' in parents and name ='${DATEDIR}'" 2>/dev/null| grep $DATEDIR | head -n 1 | awk '{print $1}')
        fi
    fi

    GDRIVEDIR=""

    for FILE in $LISTA;
    do
	echo "$FILE"
	"$GDRIVEPATH"gdrive upload --parent ${GDRIVEUPL} $FILE &>/dev/null && rm $FILE
	sleep 1s
    done
    sleep 60s
done

