#!/usr/bin/env bash

rofi_dir="~/.config/polybar/rofi"
rofi_command="rofi -theme $rofi_dir/power-menu.rasi"

# Options
lock=" Lock"
suspend=" Sleep"
logout=" Logout"
reboot=" Restart"
shutdown=" Shutdown"

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -dmenu)"

if [[ -z $chosen ]]; then
	exit 0
fi

confirmed="$(~/.config/polybar/scripts/confirm.sh)"

if [[ $confirmed == "no" ]]; then
	exit 0
fi

case $chosen in
$shutdown)
	systemctl poweroff
	;;
$reboot)
	systemctl reboot
	;;
$lock)
	if [[ -f /usr/bin/i3lock ]]; then
		i3lock
	elif [[ -f /usr/bin/betterlockscreen ]]; then
		betterlockscreen -l
	fi
	;;
$suspend)
	mpc -q pause
	amixer set Master mute
	systemctl suspend
	;;
$logout)
	if [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
		openbox --exit
	elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
		bspc quit
	elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
		i3-msg exit
	fi
	;;
esac
