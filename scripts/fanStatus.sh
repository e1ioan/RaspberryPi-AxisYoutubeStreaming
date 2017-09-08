#!/bin/bash

file="/home/pi/data/fanstatus.txt" #the file where you keep your string name

val=$(cat "$file")        #the output of 'cat $file' is assigned to the $name variable

echo $val
