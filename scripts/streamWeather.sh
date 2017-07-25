#!/bin/bash

# use in Video Stream Settings -> Include text: #D  -  %c  -  FPS: #R
# #D - dynimic text (we use this script to fill this up)
# %c - date and time
# #R fps

text=$(/home/pi/scripts/weather.sh overlay 2>&1)
echo $text
curl -v -G --connect-timeout 1 --noproxy  --silent --output /dev/null "*" -u "<login>:<pass>" "http://192.168.1.57:80/axis-cgi/admin/dynamicoverlay.cgi?action=settext"  --data-urlencode "text=$text"
