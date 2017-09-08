#!/bin/bash

#                   240p       360p        480p        720p        1080p
#Resolution      426 x 240   640 x 360   854x480     1280x720    1920x1080
#Video Bitrates                   
#Maximum         700 Kbps    1000 Kbps   2000 Kbps   4000 Kbps   6000 Kbps
#Recommended     400 Kbps    750 Kbps    1000 Kbps   2500 Kbps   4500 Kbps
#Minimum         300 Kbps    400 Kbps    500 Kbps    1500 Kbps   3000 Kbps

#https://support.google.com/youtube/answer/2853702?hl=en

while true
do
  /home/pi/FFMpeg/ffmpeg -f lavfi -i anullsrc -rtsp_transport tcp -i \
		rtsp://login:pass@192.168.1.90:554/axis-media/media.amp?streamprofile=Test \
		-vcodec copy -codec:a aac  -f flv -r 25 -g 50 -s 1280x720 "rtmp://a.rtmp.youtube.com/live2/your-live-key" 
  sleep 30
done

