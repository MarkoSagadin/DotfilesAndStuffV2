#!/usr/bin/env bash

rofi_command="rofi -theme ~/.config/rofi/power_menu.rasi"

# Options
lock=" Lock"
suspend="󰤄 Sleep"
logout="󰍃 Logout"
reboot=" Restart"
shutdown=" Shutdown"

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -dmenu)"

if [[ -z $chosen ]]; then
    exit 0
fi

confirmed="$(~/.config/hypr/scripts/confirm.sh)"

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
    hyprlock
    ;;
$suspend)
    mpc -q pause
    amixer set Master mute
    systemctl suspend
    ;;
$logout)
    loginctl terminate-user $USER
    ;;
esac
