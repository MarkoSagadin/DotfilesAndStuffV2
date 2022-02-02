#!/usr/bin/env bash

. ./helper_functions.sh
check_distro
check_programs_path

sudo add-apt-repository ppa:regolith-linux/release
sudo apt update
sudo apt install i3-gaps

git clone https://github.com/i3-gnome/i3-gnome.git
cd i3-gnome
sudo make install
