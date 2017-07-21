#!/bin/bash

rrdtool graph /home/pi/www/graph.png --slope-mode --full-size-mode --width 1000 --height 400  -s 'now - 1 days' -e 'now' DEF:FPS=/home/pi/data/fps_db.rrd:fps:MAX LINE2:FPS#FF0000:Average_FPS
