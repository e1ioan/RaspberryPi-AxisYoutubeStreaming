#!/bin/bash

# use in Video Stream Settings -> Include text: #D  -  %c  -  FPS: #R
# #D - dynimic text (we use this script to fill this up)
# %c - date and time
# #R fps

text=$(/home/pi/scripts/weather.sh overlay 2>&1)
sunset=$(/home/pi/scripts/weather.sh sunset 2>&1)
sunrise=$(/home/pi/scripts/weather.sh sunrise 2>&1)

varNow=$(date +%H%M)

if [[ "$varNow" == "$sunset" ]]; then
	# turn auto tracking off
	curl -s 'http://login:pass@192.168.1.90/axis-cgi/operator/param.cgi?action=update&AutoTracking.A0.Running=no'  > /dev/null 2>&1
fi

if [[ "$varNow" == "$sunrise" ]]; then
        # turn auto tracking on
        curl -s 'http://login:pass@192.168.1.90/axis-cgi/operator/param.cgi?action=update&AutoTracking.A0.Running=yes'  > /dev/null 2>&1
fi

curl -v -G --connect-timeout 1 --noproxy  --silent --output /dev/null "*" -u "login:pass" "http://192.168.1.90:80/axis-cgi/admin/dynamicoverlay.cgi?action=settext"  --data-urlencode "text=$text"  > /dev/null 2>&1
