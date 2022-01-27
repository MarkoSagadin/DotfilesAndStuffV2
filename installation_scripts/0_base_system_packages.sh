#!/usr/bin/env bash

. ./helper_functions.sh
check_distro

#### Common section ####

# Basics
install curl
install git
install tmux
install xclip
install tree
install make
install cmake
install gcc-multilib
install gcc
install g++
install unzip
install bash
install wget
# install openocd
# install gdb
# install minicom
# install picocom
install python3
# install neofetch
install zsh
install bison
# install filezilla
# install htop
install ccache
install dfu-util
# install zathura
# install yarn
install xdotool
install gperf
install file

# Fun stuff
install figlet
install lolcat

#### System specific section ####
if [ "$DISTRO" = "MANJARO" ]; then
	# Manjaro Linux specific packages, some of them are named differently as on Ubuntu
	install gvim
	install base-devel
	install python-pip
	install ninja
	install python-setuptools
	install python-wheel
	install xz
	install texlive-core
	install texlive-latexextra
	install texlive-science
	install zathura-djvu
	install zathura-pdf-mupdf
	install go
	installyay nerd-fonts-meslo
	install ttf-mac-fonts
	install transmission-gtk
	sudo npm install --global pure-prompt
	install alacritty
	install rust
	install lua
	install luarocks
	install nodejs
	install npm

	figlet "AWW YEAH, DONE!" | lolcat
else
	install software-properties-common
	install lsb-release
	install vim-gtk # gtk version, so we can paste nicely to system cliboard
	# install spotify-client
	# install python3-pip
	# install dconf-editor
	# install dconf-cli
	# install uuid-runtime
	# # Latex
	# install latexmk
	# install texlive-latex-extra
	# install texlive-science
	# # Zephyr stuff
	# install ninja-build
	# install python3-setuptools
	# install python3-wheel
	# install xz-utils
	# # Golang stuff
	# install lua5.3
	# install luarocks

	# Install a recent golang, cause apt version is veeery old
	wget https://go.dev/dl/go1.17.6.linux-amd64.tar.gz
	rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz

	# Same here, npm will also get installed
	curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
	install nodejs

	# Ubuntu is a stable distro, bla bla bla
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

	figlet "AWW YEAH, DONE!" | /usr/games/lolcat
fi
