#!/bin/sh

# To change city change the LOCATION_CODE.
LOCATION_CODE='07e4839fba1061ba866b18505548e6682d418352d3dab1274a66af54b2f7682e'
# ==============================================================================


info_to_icon() {    
    case $1 in
        'Sunny')
            echo '☀ ';;
        'Night Clear')
            echo ' ';;
        'Mostly Sunny')
            echo ' ';;
        'Partly Cloudy')
            echo ' ';;
        'Partly Cloudy Night')
            echo ' ';;
        'Mostly Cloudy')
            echo ' ';;
        'Mostly Cloudy Night')
            echo ' ';;
        'Cloudy')
            echo ' ';;
        'Scattered Showers')
            echo ' ';;
        'Rain')
            echo ' ';;
        'Foggy')
            echo ' ';;
        'Rain and Snow')
            echo '  ';;
        'Snow')
            echo ' ';;
        'Wind')
            echo ' ';;
        *)
            echo "$1";;
        esac
}


# weather_scraper.py needs to be in same dir as this script.
json=$(python ~/.config/polybar/weather_scraper.py "$LOCATION_CODE")
weather=$(echo "$json" | jq '.location.forecasts' | jq '.[0].weather')


# forecast 1
tmp1=$(echo "$weather" | jq -r '.[0].temperature')
tmp1_num=$(echo "$tmp1" | tr -d '°')

info1=$(echo "$weather" | jq -r '.[0].info')
icon1=$(info_to_icon "$info1")


# forecast 2
tmp2=$(echo "$weather" | jq -r '.[1].temperature')
if [ "$tmp2" = "null" ]
then
    # its 23:00 and the second weather is on the next day
    weather=$(echo "$json" | jq '.location.forecasts' | jq '.[1].weather')
    tmp2=$(echo "$weather" | jq -r '.[0].temperature')
    info2=$(echo "$weather" | jq -r '.[0].info')

else
    info2=$(echo "$weather" | jq -r '.[1].info')
fi

tmp2_num=$(echo "$tmp2" | tr -d '°')
icon2=$(info_to_icon "$info2")

# Set the arrow for the corresponding diff temps
if [ "$tmp1_num" -lt "$tmp2_num" ]; 
then
    tmp_diff='↗ '
elif [ "$tmp1_num" -eq "$tmp2_num" ];
then
    tmp_diff='→ '
else
    tmp_diff='↘ '
fi

# output for polybar
echo "$icon1 $tmp1 $tmp_diff $icon2 $tmp2"

