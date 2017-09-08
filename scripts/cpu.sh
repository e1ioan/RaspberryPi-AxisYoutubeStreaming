#!/bin/bash

temp_db="/home/pi/data/cpu_db.rrd"
/usr/bin/rrdtool fetch $temp_db MAX -s 'now - 2 hours' -e 'now'
