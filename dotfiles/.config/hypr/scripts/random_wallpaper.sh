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

# Run wallust to get color scheme from the wallpaper, bit skip setting
# terminal sequences (aka. terminal colors)
wallust run --skip-sequences $RANDOM_PIC

swww img $SWWW_PARAMS $RANDOM_PIC
