#!/usr/bin/haserl
content-type: text/html

<html>
<head>
<meta http-equiv="refresh" content="60">
</head>
<body>
<center>
<font face=verdana size=2>
	<br>
	<%
		date
	%>
	<br>
	<%
		/home/pi/scripts/weather.sh
	%>
	<br>
	<%
		/home/pi/scripts/graph.sh > /dev/null
	%>
<img src="../graph.png"><br><br>
 <a href="https://www.youtube.com/channel/UCRgTyO_8qEkCrEyv-sh2c3w/live">Live on Youtube</a><br>
  <a href="https://github.com/e1ioan/RaspberryPi-AxisYoutubeStreaming">Github Project</a>

</font>
</center>
</body></html> 
