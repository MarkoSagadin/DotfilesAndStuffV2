#!/usr/bin/env bash

# this prints a beautifully formatted list. bash was a mistake
nmcli -t d wifi rescan
LIST=$(
	nmcli --fields SSID,SECURITY,BARS device wifi list | sed '/^--/d' |
		sed 1d | sed -E "s/WPA*.?\S/~~/g" |
		sed "s/~~ ~~/~~/g;s/802\.1X//g;s/--/~~/g;s/  *~/~/g;s/~  */~/g;s/_/ /g" |
		sed "s/▂▄▆█/󰤨/g" |
		sed "s/▂▄▆ /󰤥/g" |
		sed "s/▂▄  /󰤢/g" |
		sed "s/▂   /󰤟/g" |
		column -t -s '~'
)

DISABLE_WIFI="          Disable WiFi 󰤮 "
ENABLE_WIFI="          Enable WiFi 󰤨 "

# get current connection status
CONSTATE=$(nmcli -fields WIFI g)
if [[ "$CONSTATE" =~ "enabled" ]]; then
	TOGGLE=$DISABLE_WIFI
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	TOGGLE=$ENABLE_WIFI
fi

WIFI_MENU_THEME=~/.config/polybar/rofi/wifi-menu.rasi
WIFI_PASSWORD_THEME=~/.config/polybar/rofi/wifi-password.rasi

# display menu; store user choice
CHENTRY=$(echo -e "$TOGGLE\n$LIST" | uniq -u | rofi -dmenu -selected-row 1 -theme $WIFI_MENU_THEME)
# store selected SSID
CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')

if [ "$CHENTRY" = "" ]; then
	exit
elif [ "$CHENTRY" = "$DISABLE_WIFI" ]; then
	nmcli radio wifi off
elif [ "$CHENTRY" = "$ENABLE_WIFI" ]; then
	nmcli radio wifi on
else
	# get list of known connections
	KNOWNCON=$(nmcli connection show)

	# If the connection is already in use, then this will still be able to get the SSID
	if [ "$CHSSID" = "*" ]; then
		CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
	if [[ $(echo "$KNOWNCON" | grep "$CHSSID") = "$CHSSID" ]]; then
		nmcli con up "$CHSSID"
	else
		if [[ "$CHENTRY" =~ "" ]]; then
			WIFIPASS=$(echo " Press Enter if network is saved" | rofi -dmenu -lines 1 -theme $WIFI_PASSWORD_THEME)
		fi
		if nmcli dev wifi con "$CHSSID" password "$WIFIPASS"; then
			notify-send 'Connection successful'
		else
			notify-send 'Connection failed'
		fi
	fi
fi
