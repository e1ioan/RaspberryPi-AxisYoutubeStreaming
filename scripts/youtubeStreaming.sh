#!/bin/bash

fps_db="/home/pi/data/fps_db.rrd"

if [ ! -e "$fps_db" ]; then
	/usr/bin/rrdtool create $fps_db --step 60 DS:fps:GAUGE:120:0:60 RRA:MAX:0.5:1:10080
fi

# --step 60 = we write in every 60 seconds
# DS - dataset type
# fps - our field
# GAUGE - the value in our field should be kept the way it is
# 120 - time out, if data is not inserted in 120s, insert 0
# 0 - min value
# 60 - max value


while true
do
  /home/pi/FFMpeg/ffmpeg -f lavfi -i anullsrc -thread_queue_size 512 -rtsp_transport tcp -i rtsp://login:pass@camera-ip:554/axis-media/media.amp -vcodec copy -codec:a aac  -f flv  -r 30 "rtmp://a.rtmp.youtube.com/live2/<youtube-live-key>" 2> >(
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

