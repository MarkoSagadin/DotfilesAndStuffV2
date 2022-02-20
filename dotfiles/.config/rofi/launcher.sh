#!/usr/bin/env bash

theme_path="~/.config/rofi/rofi-theme.rasi"
rofi -no-lazy-grab -show drun -modi drun -theme "$theme_path" -window-title "rofi-launcher"
