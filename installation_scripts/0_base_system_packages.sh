#!/usr/bin/env bash

set -euo pipefail

. ./helper_functions.sh
check_distro

remove_snap=""
install_firefox_deb=""

if [ "$DISTRO" = "UBUNTU" ]; then
    ask_yes_no "Do you want to completly remove Snap?" remove_snap
    ask_yes_no "Do you want to install Firefox as a Debian package and not as Snap package?" install_firefox_deb
    
    if [ "$remove_snap" = "Y" ]; then
        ./support_scripts/remove_snap.sh
    fi

    if [ "$install_firefox_deb" = "Y" ]; then
        ./support_scripts/install_firefox_deb.sh
    fi
fi

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
	lolcat \
   	vim

#### System specific section ####
if [ "$DISTRO" = "MANJARO" ]; then
	# Manjaro Linux specific packages, some of them are named differently as on Ubuntu
	install base-devel \
		python-pip \
		ninja \
		python-setuptools \
		python-wheel \
		xz \
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
		cmake \
		python3-pip \
		dconf-editor \
		dconf-cli \
		uuid-runtime \
		ninja-build \
		python3-setuptools \
		python3-wheel \
        python3-pip \
        pipx \
		xz-utils

    rm kitware-archive*
    
    pipx ensurepath

	# Install a recent golang, cause apt version is veeery old
	wget https://go.dev/dl/go1.23.3.linux-amd64.tar.gz
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go1.23.3.linux-amd64.tar.gz
	rm go1.23.3.linux-amd64.tar.gz

	# Same here, npm will also get installed
	curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
	install nodejs

	# Same here, install latest lua
	wget http://www.lua.org/ftp/lua-5.4.7.tar.gz
	tar -xf lua-5.4.7.tar.gz
	cd lua-5.4.7
	make linux test
	sudo make install
	cd .. && rm -fr lua-5.4.7*

	# Same here, install latest luarocks package manager
	wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
	tar zxpf luarocks-3.11.1.tar.gz
	cd luarocks-3.11.1
	./configure --with-lua-include=/usr/local/include
	make
	sudo make install
	cd .. && rm -fr luarocks-3.11.1*

	# Ubuntu is a stable distro, bla bla bla
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # LLVM tooling, like clang-tidy, clang-format, clang-sa
    wget https://apt.llvm.org/llvm.sh
    chmod +x llvm.sh
    sudo ./llvm.sh 18 all # Install all packages, version 18
    rm llvm.sh
fi

echo ""
echo "##########################################"
echo "Stage 0 was installed"
echo "##########################################"
