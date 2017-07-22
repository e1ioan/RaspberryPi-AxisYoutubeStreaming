# Stream live video to youtube using a Raspberry Pi and an Axis IP camera

1) Get a RasperyPi (I'm using Raspberry Pi 3 model b)
2) Download Noobs (https://www.raspberrypi.org/downloads/noobs/) unzip it, copy everything on a sd card and boot your Pi.
3) Install Raspbian

This will take a few minutes. When done, you'll have to download and compile the ffmjpeg from source with Hardware Accelerated x264 Encoding. Here are the steps:

Open terminal and type in the following commands some of them might need "sudo":

First we need to install all of the dependencies required to compile FFMpeg, as well as the standard tools for compiling programs (gcc, automake, etc.)
Type in the following command:
```
sudo apt-get update
sudo apt-get install autoconf automake build-essential libass-dev libfreetype6-dev \
libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev
```

Once that's done, we're ready to pull the latest FFMpeg from the git repository:
```
cd ~
git clone https://github.com/ffmpeg/FFMpeg --depth 1
```

Once that's done, you should now have the FFMpeg sources in your ~/FFMpeg folder.
We're going to compile FFMpeg now, type in the following commands:
```
cd ~/FFMpeg
./configure --enable-gpl --enable-nonfree --enable-mmal --enable-omx --enable-omx-rpi
```

If everything goes well, it should take a few minutes to configure. You won't really see anything on the screen until it's done, then you'll see a lot of information about the different options that were enabled.
Now we're ready to compile.
```
make -j4 
```

The -j4 tells the compiler to use all 4 cores of the RPi2/RPi3 which speeds up compilation considerably. With an RPi2, expect to wait about 15-20 minutes for the compile to complete. With an RPi3, the process will be quicker.
Once the process is done, you should have a working version of FFMpeg, complete with OMX encoding support. Double check that it's enabled properly by typing:
```
./ffmpeg -encoders | grep h264_omx
```

If it worked, you should see:
```
V..... h264_omx             OpenMAX IL H.264 video encoder (codec h264)
```

At this point you can install FFMpeg on your system if you would like by typing:
make install
Or simply keep it and use it in your ~/FFMpeg folder. It's up to you.

Here's an example command line, for those of you not familiar with FFMpeg encoding:
```
./ffmpeg -c:v h264_mmal -i <inputfile.mp4> -c:v h264_omx -c:a copy -b:v 1500k <outputfile.mp4>
```

The first -c:v h264_mmal tells FFMpeg to use h264_mmal hardware accelerated decoder
The second -c:v h264_omx tells FFMpeg to use the h264_omx encoder
The -c:a copy tells FFMpeg to simply copy any audio tracks without transcoding
The -b:v tells FFMpeg to set the average video bitrate target to 1500Kbit. You can set this to whatever you want to get the desired file size.

You can type ffmpeg -h full to get a complete list of commands, it's quite extensive. You can also check the ffmpeg man page.
When you run the command, open another window and run top, you'll see that the CPU usage is very low, around 45% or so, telling you that the RPi is using hardware acceleration.

Some things to keep in mind:
1) This encoder is VERY basic, it does not include all of the bells and whistles that libx264 has, you're basically able to scale the video and lower or increase the bitrate, that's pretty much it.
2) To my knowledge, there's no GUI program that supports this feature, so you're stuck encoding on the command line.
3) The use of ANY kind of scaling or filters will drastically slow down the encode because it uses the RPi's CPU.

Now that the ffmpeg is installed, you can start streaming:
```
/home/pi/FFMpeg/ffmpeg  -f lavfi -i anullsrc -rtsp_transport tcp -i rtsp://user:password@camera-ip:554/axis-media/media.amp -vcodec copy -codec:a aac -f flv -r 30 -s 640x480 "rtmp://a.rtmp.youtube.com/live2/<youtube-live-key>"
```

... or even better command:
```
/home/pi/FFMpeg/ffmpeg -f lavfi -i anullsrc -thread_queue_size 512 -rtsp_transport tcp -i rtsp://login:password@camera-ip:554/axis-media/media.amp  -vcodec copy -codec:a aac -pix_fmt yuvj420p -f flv -r 30  "rtmp://a.rtmp.youtube.com/live2/<key>"
```

Put is in a script that will restart the process if it dies. Use nano:
```
nano youtubeStreaming.sh
```
Paste the following code in nano (replace your IP, login, password, and youtube live key)
```
#!/bin/bash

while true
do
  /home/pi/FFMpeg/ffmpeg  -f lavfi -i anullsrc -rtsp_transport tcp -i rtsp://user:password@camera-ip:554/axis-media/media.amp -vcodec copy -codec:a aac -f flv -r 30 -s 640x480 "rtmp://a.rtmp.youtube.com/live2/<youtube-live-key>"
sleep 2
done
```

Save it and then add it to crontab to start it at boot:
```
crontab -e
```

and add at the end:
```
@reboot ~/youtubeStreaming.sh
```

Also... maybe it would be a good idea to restart your Pi daily at midnight, just in case something goes wrong:
```
sudo nano /etc/crontab
```

then add at the end:
```
0  0     * * *   root    reboot
```

That's it.



Thanks https://www.reddit.com/r/raspberry_pi/comments/5677qw/hardware_accelerated_x264_encoding_with_ffmpeg/


# Raspbery Pi - Custom MOTD  

Save the motd.sh script in the directory /etc/profile.d and it will be executed after the login.

Remove the default MOTD. It is located in /etc/motd.
```
$ sudo rm /etc/motd
```

Remove the "last login" information. Disable the PrintLastLog option from the sshd service. Edit the /etc/ssh/sshd_config file and change the line ```PrintLastLog yes``` to ```PrintLastLog no```:
```
$ sudo nano /etc/ssh/sshd_config
```

Restart the sshd service.


# Monitor FPS average over the web

Install mini_httpd and haserl on your Raspberry Pi:
```
sudo apt-get install mini_httpd
sudo apt-get install haserl
sudo apt-get install rrdtool
```

```mini_httpd``` - a small webserver that works perfect on Rasperry Pi
```haserl``` - a cgi scripting program for embedded environments (very easy to use)
```rrdtool``` - high performance data logging and graphing system

Configure mini_httpd by editing /etc/mini-httpd.conf
```
sudo nano /etc/mini-httpd.conf
```

and make it look like this:
```
# Example config for mini_httpd.
# Author: Marvin Stark <marv@der-marv.de>

# Uncomment this line for turning on ssl support.
#ssl

# On which host mini_httpd should bind?
#host=localhost

# On which port mini_httpd should listen?
port=80

# Which user mini_httpd should use?
#user=nobody
user=pi

# Run in chroot mode?
#chroot # yes
nochroot # no

# Working directory of mini_httpd.
#dir=<work_dir>

# We are the web files stored?
# Please change this to your needs.
#data_dir=/usr/share/mini-httpd/html
data_dir=/home/pi/www

# CGI path
cgipat=cgi-bin/*

# Which certificate to use?
#certfile=<certfile>

# Which logfile to use?
logfile=/var/log/mini-httpd.log

# Which pidfile to use?
pidfile=/var/run/mini-httpd.pid

# Which charset to use?
charset=iso-8859-1

```

Stop and start mini-httpd:
```
sudo service mini-httpd stop
sudo service mini-httpd start
```

Create www and www/cgi-bin directories
```
mkdir ~/www
mkdir ~/www/cgi-bin
```

Now you can create html files in www (index.html is default) and .cgi files in ~/www/cgi-bin/.
To see few example of cgi files, look here: 
https://github.com/e1ioan/home-automation-openwrt-arduino/tree/master/openwrt/www/cgi-bin

To log fps average will use rrdtool. Change the youtubeStreaming.sh to look like this:
```
#!/bin/bash

while true
do
  /home/pi/FFMpeg/ffmpeg -f lavfi -i anullsrc -thread_queue_size 512 -rtsp_transport tcp -i rtsp://login:pass@camera-ip:554/axis-media/media.amp  -vcodec copy -codec:a aac -pix_fmt yuvj420p -f flv -r 30  "rtmp://a.rtmp.youtube.com/live2/youtube-live-key" 2> >(
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
					rrdtool update /home/pi/data/fps_db.rrd N:$averageFPS
					#echo "$averageFPS"
					# after saving the average, reset the values
			                counter=0
			                sumFPS=0
				fi
				#printf >&2 'fps: %s count: %s sum: %s average: %s\n' "$fps" "$counter" "$sumFPS" "$averageFPS"
			fi
		done
	)
  sleep 2
done

```

Create the rrdtool database:
```
mkdir ~/data
rrdtool create /home/pi/data/fps_db.rrd --step 60 DS:fps:GAUGE:120:0:60 RRA:MAX:0.5:1:525600

# --step 60 = we write in every 60 seconds
# DS - dataset type
# fps - our field
# GAUGE - the value in our field should be kept the way it is
# 120 - time out, if data is not inserted in 120s, insert 0
# 0 - min value
# 60 - max value
```

Restart the Pi to have the new script write data in the database.

To query the database, you can use
```
rrdtool fetch /home/pi/data/fps_db.rrd MAX -s 'now - 2 hours' -e 'now'
```

To create a png image with a graph of FPS over a period of time, use
```
rrdtool graph /home/pi/graph.png -s 'now - 1 days' -e 'now' DEF:FPS=/home/pi/data/fps_db.rrd:fps:MAX LINE1:FPS#FF0000:Average_FPS
```

Now, let's combine mini-httpd, cgi-bin, rrdtool to get everything on the web!
For that, you can get all the files necessary from here. Copy all files from www to ```~/www```, all the files from www/cgi-bin to ```~/www/cgi-bin```, all the files from "scripts" to ```~/scripts```. Run the following command for each script from ```~/scripts``` and from ```~/www/cgi-bin```:
```
chmod +x script.sh 
```

Restart your Pi:
```
sudo reboot
```

... and check to see if everything works fine by going to http://your-pi-IP


Here is how it will look if everything works the way it should:

![Picture](https://raw.githubusercontent.com/e1ioan/RaspberryPi-AxisYoutubeStreaming/master/fps.png "The picure should be here")
