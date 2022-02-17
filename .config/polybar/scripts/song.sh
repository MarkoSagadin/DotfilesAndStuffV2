#!/bin/env bash

function scroll() {
	prefix="$1"
	scrolling="$2"
	temp="$(echo "$scrolling" | sed "s/^\(.\{20\}\)\(.*\)$/\1[\2]/" | sed "s/\[ *\]$//" | sed "s/\[.*\]$//")"
	if [ "$(echo -n $scrolling | wc -c)" -gt 20 ]; then

		zscroll -l 20 \
			--delay 0.3 \
			--before-text "$prefix" \
			--after-text " " \
			--scroll-padding " 󰝚 " \
			--match-command "$(dirname $0)/get_spotify_status.sh --status" \
			--match-text "Playing" "--scroll 1" \
			--match-text "Paused" "--scroll 0" \
			--match-text "No player is running" "--timeout 0.1" \
			--update-check true "$(dirname $0)/get_spotify_status.sh" &

		# --update-check true "echo '$scrolling'" &

		wait
	else
		echo "$prefix $temp"
	fi
}

function get_artist() {
	artist=$(playerctl -p spotify metadata --format "{{ artist }}" 2>/dev/null)
	echo "$(echo "$artist" | sed -e "s/[[(]....*[])]*//g" | sed "s/ *$//" | sed "s/^\(.\{20\}[^ ]*\)\(.*\)$/\1[\2]/" | sed "s/\[ *\]$//" | sed "s/\[.*\]$/.../")"
}

function get_title() {
	echo "$(playerctl -p spotify metadata --format "{{title}}" 2>/dev/null | sed 's/'\''/\\'\''/g')"
}

STATUS=$(playerctl --player=spotify status 2>/dev/null)

if [[ ! -z $STATUS ]]; then

	# Spotify is running, scroll
	artist=$(get_artist)
	title=$(get_title)
	scroll "%{T2}%{F#1DB954}󰓇 %{F-}%{T-}" "$artist - $title"
else
	# Spotify is not running, stop scroll-padding
	exit 1
fi
