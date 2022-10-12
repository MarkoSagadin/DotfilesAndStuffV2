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
	gcc-multilib \
	gcc \
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
	flameshot \
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
	remove vim
	install gvim \
		base-devel \
		python-pip \
		ninja \
		python-setuptools \
		python-wheel \
		xz \
		texlive-core \
		texlive-latexextra \
		texlive-science \
		zathura-djvu \
		zathura-pdf-mupdf \
		go \
		transmission-gtk \
		rust \
		lua \
		luarocks \
		nodejs \
		firefox \
		cmake \
		npm
else
	# Needed for latest cmake binary
	wget https://apt.kitware.com/kitware-archive.sh
	sudo bash kitware-archive.sh
	install software-properties-common \
		lsb-release \
		g++ \
		vim-gtk \
		cmake \
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
		libncurses5

	# Install a recent golang, cause apt version is veeery old
	wget https://go.dev/dl/go1.17.6.linux-amd64.tar.gz
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz
	rm go1.17.6.linux-amd64.tar.gz

	# Same here, npm will also get installed
	curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
	install nodejs

	# Same here, install latest lua
	curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
	tar -zxf lua-5.3.5.tar.gz
	cd lua-5.3.5
	make linux test
	sudo make install
	cd .. && rm -fr lua-5.3.5*

	# Same here, install latest luarocks package manager
	wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz
	tar zxpf luarocks-3.8.0.tar.gz
	cd luarocks-3.8.0
	./configure --with-lua-include=/usr/local/include
	make
	sudo make install
	cd .. && rm -fr luarocks-3.8.0*

	# Ubuntu is a stable distro, bla bla bla
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

figlet "AWW YEAH, DONE!" | lolcat
