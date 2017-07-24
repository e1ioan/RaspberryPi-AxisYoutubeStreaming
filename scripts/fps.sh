#!/bin/bash

fps_db="/home/pi/data/fps_db.rrd"
/usr/bin/rrdtool fetch $fps_db MAX -s 'now - 2 hours' -e 'now'
