#!/usr/bin/env bash

. ./helper_functions.sh
check_distro
check_programs_path

cd $PROGRAMS_PATH

sudo add-apt-repository ppa:regolith-linux/release
sudo apt update
install i3-gaps

git clone https://github.com/i3-gnome/i3-gnome.git
cd i3-gnome
sudo make install

cd $PROGRAMS_PATH
#Picom
install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson

git clone https://github.com/yshui/picom.git
cd picom
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
ninja -C build install
