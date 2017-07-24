#!/bin/bash

fps_db="/home/pi/data/fps_db.rrd"

# if the rrdtool database is not existent, create it
if [ ! -e "$fps_db" ]; then
	/usr/bin/rrdtool create $fps_db --step 60 DS:fps:GAUGE:120:0:60 RRA:MAX:0.5:1:10080
fi

#rrdtool create /home/pi/data/fps_db.rrd --step 60 DS:fps:GAUGE:120:0:60 RRA:MAX:0.5:1:10080
# --step 60 = we write in every 60 seconds
# DS - dataset type
# fps - our field
# GAUGE - the value in our field should be kept the way it is
# 120 - time out, if data is not inserted in 120s, insert 0
# 0 - min value
# 60 - max value


#                   240p       360p        480p        720p        1080p
#Resolution      426 x 240   640 x 360   854x480     1280x720    1920x1080
#Video Bitrates                   
#Maximum         700 Kbps    1000 Kbps   2000 Kbps   4000 Kbps   6000 Kbps
#Recommended     400 Kbps    750 Kbps    1000 Kbps   2500 Kbps   4500 Kbps
#Minimum         300 Kbps    400 Kbps    500 Kbps    1500 Kbps   3000 Kbps

#https://support.google.com/youtube/answer/2853702?hl=en

while true
do
  /home/pi/FFMpeg/ffmpeg -f lavfi -i anullsrc -thread_queue_size 512 -rtsp_transport tcp -i rtsp://login:pass@your-camera-ip:554/axis-media/media.amp -vcodec copy -codec:a aac  -f flv  -r 30 "rtmp://a.rtmp.youtube.com/live2/youtube-live-key" 2> >(
		counter=0
		sumFPS=0
		averageFPS=0
		nowMinute=$(date +"%M")
		lastLog=$(date +"%M")
		tr \\r \\n | while read -r line; do
			if [[ $line =~ fps=([[:space:][:digit:]]+) ]]; then
				fps=${BASH_REMATCH[1]}
				((++counter))
				sumFPS=$(($sumFPS+$fps))
				averageFPS=$((sumFPS/counter))
				nowMinute=$(date +"%M")
				if [[ "$lastLog" != "$nowMinute" ]]; then
					lastLog="$nowMinute"
					# printf '%s\t%s\n' $(date +"%Y-%m-%d-%H") "$averageFPS" >> /home/pi/data/logfile
					# save to database, N means now
					rrdtool update $fps_db N:$averageFPS
					#echo "$averageFPS"
					# after saving the average, reset the values
			                counter=0
			                sumFPS=0
					averageFPS=0
				fi
				#printf >&2 'fps: %s count: %s sum: %s average: %s\n' "$fps" "$counter" "$sumFPS" "$averageFPS"
			fi
		done
	)

  sleep 2
done

