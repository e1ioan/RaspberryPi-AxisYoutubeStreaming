#!/usr/bin/haserl
content-type: text/html

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
<title>
FPS Over Time
</title>

<%
 /home/pi/scripts/graph.sh > /dev/null
%>
 </head>
<body style="font-family: Arial;border: 0 none;">
<center>
  <img src="../graph.png">
</center>
</body>
</html>

