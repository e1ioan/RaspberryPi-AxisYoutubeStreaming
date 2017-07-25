#!/bin/bash

varJson="$(curl -s 'http://api.openweathermap.org/data/2.5/weather?lat=45.96&lon=24.67&units=metric&APPID=<your-key>' | jq -r '.')"
varTemp=$(<<<"$varJson" jq -r '. | .main.temp')
varTempF=$(echo "scale=2;((9/5) * $varTemp) + 32" |bc)
varWeather=$(<<<"$varJson" jq -r '. | .weather[0].main')
varWeatherDescription=$(<<<"$varJson" jq -r '. | .weather[0].description')
varIcon=$(<<<"$varJson" jq -r '. | .weather[0].icon')
labelPlace=$(<<<"$varJson" jq -r '. | .name')
labelCountry=$(<<<"$varJson" jq -r '. | .sys.country')

#labelPlace has the real location (Agnita) we'll use Barghis
labelPlace="Barghis"

if [[ $1 == "overlay" ]]; then
	labelWeather="$(echo "$labelPlace - $labelCountry: $varTemp'C ($varTempF F) - $varWeather ($varWeatherDescription)")"
	echo $labelWeather
else
	labelWeather="$(echo "<b>$labelPlace - $labelCountry:</b> $varTemp'C ($varTempF F) - $varWeather ($varWeatherDescription)")"
	echo $labelWeather
	echo "<br><img src=\"http://openweathermap.org/img/w/"$varIcon".png\">"
fi
