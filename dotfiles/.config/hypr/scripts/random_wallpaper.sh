#!/bin/bash

cd ~/Wallpapers

PICS=($(find . -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))

RANDOM_PIC=${PICS[$RANDOM % ${#PICS[@]}]}

echo $RANDOM_PIC
# Transition config

FPS=144

transitions=("wipe")

rand=$(($RANDOM % ${#transitions[@]}))

TYPE=${transitions[$rand]}

DURATION=10

SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

current_monitor=$(hyprctl -j activeworkspace | jq .monitor | tr -d '"')

swww query || swww init && swww img -o $current_monitor $SWWW_PARAMS $RANDOM_PIC

# ${scriptsDir}/PywalSwww.sh

# sleep 1

# ${scriptsDir}/RefreshNoWaybar.sh
