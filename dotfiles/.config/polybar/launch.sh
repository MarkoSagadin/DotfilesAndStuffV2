#!/usr/bin/env bash

# Terminate already running bar instances
killall polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar

backlight=$(ls /sys/class/backlight)

if [[ $backlight == "intel_backlight" ]]; then
	polybar main -c $(dirname $0)/intel_conf.ini &
elif [[ $backlight == "amdgpu_bl1" ]]; then
	polybar main -c $(dirname $0)/amdgpu_conf.ini &
else
	echo "This backlight is not supported"
fi
