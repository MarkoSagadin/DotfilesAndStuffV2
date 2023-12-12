#!/bin/sh

export XAUTHORITY=~/.Xauthority
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

if [[ "$1" == "plugged" ]]; then
	SOUND_FILE="power-plug"
	ICON_FILE="battery-charging"
	MESSAGE="Plugged"
else
	SOUND_FILE="power-unplug"
	ICON_FILE="power-plug-unplugged"
	MESSAGE="Unplugged"

fi

notify-send --icon ~/.config/icons/$ICON_FILE.png "$MESSAGE" --expire-time=4000

# Without --server flag it does not start the sound from the udev rule.
/usr/bin/sudo -u $USER /usr/bin/paplay \
	--server=/run/user/1000/pulse/native \
	/usr/share/sounds/freedesktop/stereo/$SOUND_FILE.oga >/dev/null 2>&1
