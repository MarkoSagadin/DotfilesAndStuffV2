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

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 0)"

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

# You can work with this when you figure out how to make a nice prompt menu

# Confirmation
# confirm_exit() {
# 	rofi -dmenu -i -no-fixed-num-lines -p "Are You Sure? : " \
# 		-theme $rofi_dir/confirm.rasi
# }

# case $chosen in
# $shutdown)
# 	ans=$(confirm_exit &)
# 	if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
# 		systemctl poweroff
# 	elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
# 		exit 0
# 	fi
# 	;;

# $reboot)
# 	ans=$(confirm_exit &)
# 	if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
# 		systemctl reboot
# 	elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
# 		exit 0
# 	fi
# 	;;
# $lock)
# 	if [[ -f /usr/bin/i3lock ]]; then
# 		i3lock
# 	elif [[ -f /usr/bin/betterlockscreen ]]; then
# 		betterlockscreen -l
# 	fi
# 	;;
# $suspend)
# 	ans=$(confirm_exit &)
# 	if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
# 		mpc -q pause
# 		amixer set Master mute
# 		systemctl suspend
# 	elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
# 		exit 0
# 	fi
# 	;;
# $logout)
# 	ans=$(confirm_exit &)
# 	if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
# 		if [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
# 			openbox --exit
# 		elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
# 			bspc quit
# 		elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
# 			i3-msg exit
# 		fi
# 	elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
# 		exit 0
# 	fi
# 	;;
# esac
