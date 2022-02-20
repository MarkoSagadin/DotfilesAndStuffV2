#!/usr/bin/env bash

SIGNAL_STRENGHT=$(
	nmcli dev wifi list | awk '/\*/{if (NR!=1) {print $9}}' |
		sed "s/▂▄▆█/󰤨/g" |
		sed "s/▂▄▆_/󰤥/g" |
		sed "s/▂▄__/󰤢/g" |
		sed "s/▂___/󰤟/g"
)

STATE=$(nmcli g | awk '/\*/{if (NR!=1) {print $0}}')

# get current connection status
CONSTATE=$(nmcli -fields WIFI g)
if [[ "$CONSTATE" =~ "enabled" ]]; then
	STATUS=$(
		nmcli dev wifi list | awk '/\*/{if (NR!=1) {print $9}}' |
			sed "s/▂▄▆█/󰤨/g" |
			sed "s/▂▄▆_/󰤥/g" |
			sed "s/▂▄__/󰤢/g" |
			sed "s/▂___/󰤟/g"
	)

elif [[ "$CONSTATE" =~ "disabled" ]]; then
	STATUS="󰤮"
fi
echo $STATUS
