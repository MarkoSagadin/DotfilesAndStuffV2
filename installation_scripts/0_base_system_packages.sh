#!/usr/bin/env bash

. ./helper_functions.sh
check_distro

#### Common section ####

# Basics
install curl \
	git \
	tmux \
	xclip \
	tree \
	make \
	cmake \
	gcc-multilib \
	gcc \
	g++ \
	unzip \
	bash \
	wget \
	openocd \
	gdb \
	minicom \
	picocom \
	python3 \
	neofetch \
	bison \
	htop \
	ccache \
	dfu-util \
	zathura \
	xdotool \
	gperf \
	file \
	figlet \
	lolcat

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
	install software-properties-common \
		lsb-release \
		vim-gtk \
		python3-pip \
		dconf-editor \
		dconf-cli \
		uuid-runtime \
		latexmk \
		texlive-latex-extra \
		texlive-science \
		ninja-build \
		python3-setuptools \
		python3-wheel \
		xz-utils \
		lua5.1 \
		luarocks

	# Install a recent golang, cause apt version is veeery old
	wget https://go.dev/dl/go1.17.6.linux-amd64.tar.gz
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz
	rm go1.17.6.linux-amd64.tar.gz

	# Same here, npm will also get installed
	curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
	install nodejs

	# Ubuntu is a stable distro, bla bla bla
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

	figlet "AWW YEAH, DONE!" | /usr/games/lolcat
fi
