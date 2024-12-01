#!/usr/bin/env bash

#Startup function
function start() {
    [[ -f "$HOME/.config/wlsunset/config" ]] && source "$HOME/.config/wlsunset/config"
    temp_low=${temp_low:-"4000"}
    temp_high=${temp_high:-"6500"}
    duration=${duration:-"900"}
    sunrise=${sunrise:-"07:00"}
    sunset=${sunset:-"19:00"}
    longitude=${longitude:-65}
    latitude=${latitude:-65}
    location=${location:-"off"}

    if [ "${location}" = "on" ]; then
        CONTENT=$(curl https://api.ipbase.com/v1/json/)
        echo $CONTENT
        echo $temp_low
        echo $temp_high
        content_longitude=$(echo $CONTENT | jq '.longitude // empty')
        longitude=${content_longitude:-"${longitude}"}
        content_latitude=$(echo $CONTENT | jq '.latitude // empty')
        latitude=${content_latitude:-"${latitude}"}
        wlsunset -l $latitude -L $longitude -t $temp_low -T $temp_high -d $duration &
    else
        wlsunset -t $temp_low -T $temp_high -d $duration -S $sunrise -s $sunset &
    fi
}

#Accepts managing parameter
case $1'' in
'off')
    pkill wlsunset
    ;;

'on')
    start
    ;;

'toggle')
    if pkill -0 wlsunset; then
        pkill wlsunset
    else
        start
    fi
    ;;
'status')
    while true; do
        if pkill -0 wlsunset; then
            text="on"
            tooltip="Night light on"
        else
            text="off"
            tooltip="Night light off"
        fi

        printf '{"text":"%s", "tooltip":"%s"}\n' "$text" "$tooltip"
        sleep 0.3
    done
    ;;
esac
