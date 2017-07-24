#!/bin/bash

fps_db="/home/pi/data/fps_db.rrd"

/usr/bin/rrdtool graph /home/pi/www/graph.png --slope-mode --full-size-mode --right-axis 1:0 --x-grid MINUTE:10:HOUR:1:HOUR:2:0:%a/%H --width 900 --height 400  -s 'now - 30 hours' -e 'now' DEF:FPS=$fps_db:fps:MAX LINE2:FPS#FF0000:Average_FPS
