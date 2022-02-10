#!/bin/bash

# The name of polybar bar which houses the main spotify module and the control modules.
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
FORMAT="{{ artist  }} - {{ title }}"

# Sends $2 as message to a polybar module $1
update_hooks() {
	while IFS= read -r id; do
		polybar-msg -p $PARENT_BAR_PID hook $1 $2 1>/dev/null 2>&1
	done < <(echo $PARENT_BAR_PID)
}

PLAYERCTL_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
	STATUS=$PLAYERCTL_STATUS
else
	STATUS="No player is running"
fi

if [ "$1" == "--status" ]; then
	echo "$STATUS"
else
	if [ "$STATUS" = "Stopped" ]; then
		update_hooks "spotify-play-pause" 2
		update_hooks "spotify-prev" 2
		update_hooks "spotify-next" 2
		echo "No music is playing"
	elif [ "$STATUS" = "Paused" ]; then
		update_hooks "spotify-play-pause" 2
		update_hooks "spotify-prev" 2
		update_hooks "spotify-next" 2
		playerctl --player=$PLAYER metadata --format "$FORMAT"
	elif [ "$STATUS" = "No player is running" ]; then
		update_hooks "spotify-play-pause" 1
		update_hooks "spotify-prev" 1
		update_hooks "spotify-next" 1
		echo "Shutting down"
	else
		update_hooks "spotify-play-pause" 3
		update_hooks "spotify-prev" 2
		update_hooks "spotify-next" 2
		playerctl --player=$PLAYER metadata --format "$FORMAT"
	fi
fi
