#!/bin/env bash

# Figure out if given app is opened, if it is not then open it in the next right
# workspace. If it is open focus to it.
find() {
	xdotool search --classname "$1"
}

CLASS=$1
APP=$2

IDS=$(find $CLASS)

if [ -z "$IDS" ]; then
	#start
	workspace_num_str=$(i3-msg -t get_workspaces | jq 'max_by(.num).num')
	workspace_num="$((workspace_num_str + 1))"
	i3-msg "workspace ${workspace_num}; exec $APP"
	i3-msg [class="$CLASS"] focus
else
	#focus
	i3-msg [class="$CLASS"] focus
fi
