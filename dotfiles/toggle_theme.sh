#! /usr/bin/env bash

CURRENT_THEME_FILE=~/.cache/current_theme
ALACRITTY_CONF=~/.config/alacritty/alacritty.yml

if [[ -f $CURRENT_THEME_FILE ]]; then
	CURRENT_THEME=$(cat $CURRENT_THEME_FILE)
else
	# No file, default is dark theme
	CURRENT_THEME=dark
fi

#Switch to a different theme
if [[ $CURRENT_THEME == "dark" ]]; then
	# Change everything to a light theme
	sed -i "s/tokyonight_storm/tokyonight_day/g" $ALACRITTY_CONF
	sed -i "s/opacity: 0.8/opacity: 1.0/g" $ALACRITTY_CONF
	export THEME=light
else
	# Change everything to a dark theme
	sed -i "s/tokyonight_day/tokyonight_storm/g" $ALACRITTY_CONF
	sed -i "s/opacity: 1.0/opacity: 0.8/g" $ALACRITTY_CONF
	export THEME=dark
fi

echo $THEME >$CURRENT_THEME_FILE
