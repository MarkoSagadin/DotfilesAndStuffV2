#!/bin/env bash

function scroll() {
	prefix="$1"
	scrolling="$2"
	temp="$(echo "$scrolling" | sed "s/^\(.\{20\}\)\(.*\)$/\1[\2]/" | sed "s/\[ *\]$//" | sed "s/\[.*\]$//")"
	if [ "$(echo -n $scrolling | wc -c)" -gt 20 ]; then
		echo "$prefix$temp"
		sleep 1.5

		zscroll -l 20 \
			--delay 0.3 \
			--before-text "$prefix" \
			--after-text "$suffix" \
			--scroll-padding "  " \
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
} #

function get_artist() {
	artist=$(playerctl -p spotify metadata --format "{{ artist }}" 2>/dev/null)
	echo "$(echo "$artist" | sed -e "s/[[(]....*[])]*//g" | sed "s/ *$//" | sed "s/^\(.\{20\}[^ ]*\)\(.*\)$/\1[\2]/" | sed "s/\[ *\]$//" | sed "s/\[.*\]$/.../")"
} #

function get_title() {
	echo "$(playerctl -p spotify metadata --format "{{title}}" 2>/dev/null | sed 's/'\''/\\'\''/g')"
} #

artist=$(get_artist)
title=$(get_title)

# [ ! -z "$(playerctl -p spotify status 2>/dev/null)" ] &&
# 	artist=$(get_artist) &&
# 	title=$(get_title) &&
# 	([ -z "$artist$title" ] && scroll "" "Spotify is not connected on this pc" || scroll "%{T2}%{F#1DB954}󰓇 %{F-}%{T-}" "$artist - $title") ||
# 	exit 1

# 	if [ "$STATUS" = "Stopped" ]; then
# 		update_hooks "spotify-play-pause" 2
# 		update_hooks "spotify-prev" 2
# 		update_hooks "spotify-next" 2
# 		echo "No music is playing"
# 	elif [ "$STATUS" = "Paused" ]; then
# 		update_hooks "spotify-play-pause" 2
# 		update_hooks "spotify-prev" 2
# 		update_hooks "spotify-next" 2
# 		playerctl --player=$PLAYER metadata --format "$FORMAT"
# 	elif [ "$STATUS" = "No player is running" ]; then
# 		update_hooks "spotify-play-pause" 1
# 		update_hooks "spotify-prev" 1
# 		update_hooks "spotify-next" 1
# 		echo "Shutting down"
# 	else
# 		update_hooks "spotify-play-pause" 3
# 		update_hooks "spotify-prev" 2
# 		update_hooks "spotify-next" 2
# 		playerctl --player=$PLAYER metadata --format "$FORMAT"
# 	fi
# fi

PARENT_BAR="main"
PARENT_BAR_PID=$(pgrep -a "polybar" | grep "$PARENT_BAR" | cut -d" " -f1)

# Set the source audio player here.
# Players supporting the MPRIS spec are supported.
# Examples: spotify, vlc, chrome, mpv and others.
# Use `playerctld` to always detect the latest player.
# See more here: https://github.com/altdesktop/playerctl/#selecting-players-to-control
PLAYER="spotify"

# Format of the information displayed
# Eg. {{ artist }} - {{ album }} - {{ title }}
# See more attributes here: https://github.com/altdesktop/playerctl/#printing-properties-and-metadata
FORMAT="{{ title }} - {{ artist }}"

# Sends $2 as message to a polybar module $1
update_hooks() {
	while IFS= read -r id; do
		polybar-msg -p $PARENT_BAR_PID hook $1 $2 1>/dev/null 2>&1
	done < <(echo $PARENT_BAR_PID)
}
STATUS=$(playerctl --player=spotify status 2>/dev/null)

if [[ ! -z $STATUS ]]; then

	# Spotify is running, scroll
	update_hooks "spotify-prev" 2
	update_hooks "spotify-next" 2

	if [[ $STATUS == "Playing" ]]; then
		update_hooks "spotify-play-pause" 3
	else
		update_hooks "spotify-play-pause" 2
	fi

	artist=$(get_artist)
	title=$(get_title)
	scroll "%{T2}%{F#1DB954}󰓇 %{F-}%{T-}" "$artist - $title"
else
	# # Spotify is not running, stop scroll-padding
	update_hooks "spotify-play-pause" 1
	update_hooks "spotify-prev" 1
	update_hooks "spotify-next" 1
	exit 1
fi
