#!/bin/bash

while true
do
	/home/pi/FFMpeg/ffmpeg -rtsp_transport tcp -i rtsp://login:pass@192.168.1.80:554/axis-media/media.amp?streamprofile=Bandwidth \
		-vcodec copy -codec:a aac -flags +global_header -f segment -segment_time 600 \
		-segment_format_options movflags=+faststart -strftime 1 /media/usb/video-%Y-%m-%d_%H-%M-%S.mp4
	sleep 10
done

