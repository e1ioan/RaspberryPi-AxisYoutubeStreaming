#!/bin/bash

varJson="$(curl -s 'http://api.openweathermap.org/data/2.5/weather?lat=45.96&lon=24.67&units=metric&lang=ro&APPID=your-own-appid' | jq -r '.')"
varTemp=$(<<<"$varJson" jq -r '. | .main.temp')
varTempF=$(echo "scale=2;((9/5) * $varTemp) + 32" |bc)
varWeather=$(<<<"$varJson" jq -r '. | .weather[0].main')
varWeatherDescription=$(<<<"$varJson" jq -r '. | .weather[0].description')
# this replaces romanian chars with the en equivalent
varWeatherDescriptionNoRoChar=$(echo "$varWeatherDescription" | iconv -f utf-8 -t us-ascii//TRANSLIT)

varIcon=$(<<<"$varJson" jq -r '. | .weather[0].icon')
labelPlace=$(<<<"$varJson" jq -r '. | .name')
labelCountry=$(<<<"$varJson" jq -r '. | .sys.country')

varSunset=$(<<<"$varJson" jq -r '. | .sys.sunset')
varSunrise=$(<<<"$varJson" jq -r '. | .sys.sunrise')

#labelPlace has the real location (Agnita) we'll use Barghis
labelPlace="Barghis"

case "$1" in

overlay)
	labelWeather="$(echo "$labelPlace - $labelCountry: $varTemp'C ($varTempF F) - $varWeather ($varWeatherDescriptionNoRoChar)")"
	echo $labelWeather
;;

sunset)
	echo $(date -d @"$varSunset" +%H%M)
;;

sunrise)
	echo $(date -d @"$varSunrise" +%H%M)
;;

*)
	labelWeather="$(echo "<b>$labelPlace - $labelCountry:</b> $varTemp'C ($varTempF F) - $varWeather ($varWeatherDescription)")"
	echo $labelWeather
	echo "<br><img src=\"http://openweathermap.org/img/w/"$varIcon".png\">"
esac

