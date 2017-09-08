#!/bin/bash

#https://github.com/prasmussen/gdrive

# directory containing "gdrive" executable
GDRIVEPATH="/home/pi/gdrive/"
# main directory on google drive
GDRIVECONT="pi-backup"

GDRIVEDIR=$("$GDRIVEPATH"gdrive list --query "mimeType contains 'folder' and name ='${GDRIVECONT}' " 2>/dev/null| grep ${GDRIVECONT} | head -n 1 | awk '{print $1}')
echo "$GDRIVEDIR"
"$GDRIVEPATH"gdrive upload --recursive --parent ${GDRIVEDIR}  /home/pi/scripts
"$GDRIVEPATH"gdrive upload --recursive --parent ${GDRIVEDIR}  /home/pi/www
