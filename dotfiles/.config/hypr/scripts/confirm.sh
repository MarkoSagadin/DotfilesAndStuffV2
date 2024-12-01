#!/usr/bin/env bash

rofi_command="rofi -theme ~/.config/rofi/confirm.rasi"

# Options
yes="󰗠"
no="󰅙"

# Variable passed to rofi
options="$yes\n$no"

chosen="$(echo -e "$options" | $rofi_command -p 'Are you sure?' -dmenu)"

if [[ $chosen = $yes ]]; then
    echo "yes"
else
    echo "no"
fi
