#!/usr/bin/env bash

# Send a notification if the laptop battery is either low
# or is fully charged.

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

# Battery percentage at which to notify
LOW_LEVEL=30
CRITICAL_LEVEL=15
BATTERY_DISCHARGING=$(acpi -b | grep "Battery 0" | grep -c "Discharging")
BATTERY_LEVEL=$(acpi -b | grep "Battery 0" | grep -P -o '[0-9]+(?=%)')

# Use two files to store whether we've shown a notification or not (to prevent multiple notifications)
LOW_FILE=/tmp/batterylow
CRITICAL_FILE=/tmp/batterycritical
FULL_FILE=/tmp/batteryfull

# Reset notifications if the computer is charging/discharging
if [ "$BATTERY_DISCHARGING" -eq 1 ] && [ -f $FULL_FILE ]; then
	rm $FULL_FILE
elif [ "$BATTERY_DISCHARGING" -eq 0 ] && [ -f $LOW_FILE ]; then
	rm $LOW_FILE
elif [ "$BATTERY_DISCHARGING" -eq 0 ] && [ -f $CRITICAL_FILE ]; then
	rm $CRITICAL_FILE
fi

# If the battery is charging and is full (and has not shown notification yet)
if [ "$BATTERY_LEVEL" -gt 95 ] && [ "$BATTERY_DISCHARGING" -eq 0 ] && [ ! -f $FULL_FILE ]; then
	notify-send.py -a "System" "Battery full" \
		"Battery level is ${BATTERY_LEVEL}%" \
		--hint string:image-path:file://home/${USER}/.config/icons/battery-full.png
	touch $FULL_FILE

elif [ "$BATTERY_LEVEL" -le $LOW_LEVEL ] && [ "$BATTERY_DISCHARGING" -eq 1 ] && [ ! -f $LOW_FILE ]; then
	notify-send.py -a "System" "Low battery level" \
		"${BATTERY_LEVEL}% of battery remaining." \
		--hint string:image-path:file://home/${USER}/.config/icons/battery-low.png
	touch $LOW_FILE
# If the battery is low and is not charging (and has not shown notification yet)
elif [ "$BATTERY_LEVEL" -le $CRITICAL_LEVEL ] && [ "$BATTERY_DISCHARGING" -eq 1 ] && [ ! -f $CRITICAL_FILE ]; then
	notify-send.py -a "System" "Critical battery level" \
		"${BATTERY_LEVEL}% of battery remaining." \
		--hint string:image-path:file://home/${USER}/.config/icons/battery-critical.png
	touch $CRITICAL_FILE
fi
