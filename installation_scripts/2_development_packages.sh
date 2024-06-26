#!/usr/bin/env bash

. ./helper_functions.sh
check_distro
check_programs_path

# Common

# Install tmux plugin manager and install all plugins, this file should kept
# out of git.
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Not related to development, but it makes life easier when learning new commands
pip install tldr

# Neovim tooling - linters, formatters
pip install pynvim
pip install neovim

if [ "$DISTRO" = "MANJARO" ]; then
	# Manjaro specific
	install neovim ctags ripgrep fd clang
	installyay diff-so-fancy
else
	# Ubuntu specific
	# Install dependencies common to all packages
	sudo add-apt-repository ppa:aos1/diff-so-fancy
	sudo apt-get update
	install diff-so-fancy gettext libtool libtool-bin doxygen pkg-config autoconf automake

	# Install Neovim
	cd $PROGRAMS_PATH
	git clone https://github.com/neovim/neovim
	cd neovim && make
	git checkout stable
	make -j16 CMAKE_BUILD_TYPE=RelWithDebInfo # Could also be set to Release
	sudo make install

	cd $PROGRAMS_PATH
	# Rip grep
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0_amd64.deb
	sudo dpkg -i ripgrep_14.1.0_amd64.deb
	rm ripgrep_14.1.0_amd64.deb

	# Fd
	wget https://github.com/sharkdp/fd/releases/download/v10.1.0/fd_10.1.0_amd64.deb
	sudo dpkg -i fd_10.1.0_amd64.deb
	rm fd_10.1.0_amd64.deb

	# Clangformat, there was no way to just get it alone without whole
	# clang tooling, plus I had to do symlinks. Not so happy about this.
	wget https://apt.llvm.org/llvm.sh
	chmod +x llvm.sh
	sudo ./llvm.sh 17 all # Install all packages, version 17
	rm llvm.sh
fi
