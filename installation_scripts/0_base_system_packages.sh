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
	fzf \
	figlet \
	lolcat

# Install Git Large File storage
wget https://github.com/git-lfs/git-lfs/releases/download/v3.1.2/git-lfs-linux-amd64-v3.1.2.tar.gz
mkdir tmp
tar -xvf git-lfs-linux-amd64-v3.1.2.tar.gz -C tmp
sudo bash tmp/install.sh
rm -fr tmp
rm -fr git-lfs-linux-amd64-v3.1.2.tar.gz

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
	install transmission-gtk
	install alacritty
	install rust
	install lua
	install luarocks
	install nodejs
	install npm
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
		luarocks \  # arm-none-eabi-gdb fails otherwise
	libncurses5

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
fi

figlet "AWW YEAH, DONE!" | lolcat
