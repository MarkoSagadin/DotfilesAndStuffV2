#!/usr/bin/env bash

. ./helper_functions.sh
check_distro
check_programs_path

# # Install dependencies common to all packages
install ninja-build gettext libtool libtool-bin doxygen pkg-config autoconf automake

# # Install Neovim
cd $PROGRAMS_PATH
git clone https://github.com/neovim/neovim
cd neovim && make
git checkout stable
make -j16 CMAKE_BUILD_TYPE=RelWithDebInfo # Could also be set to Release
sudo make install

# Install Ctags
cd $PROGRAMS_PATH
git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh
./configure #--prefix=/where/you/want # defaults to /usr/local
make -j16
sudo make install # may require extra privileges depending on where to install
cd ..
rm -fr ctags

# Install tmux plugin manager and install all plugins, this file should kept
# out of git.
cd $HOME
git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
bash .tmux/plugins/tpm/tpm
bash .tmux/plugins/tpm/scripts/install_plugins.sh

# Neovim tooling - linters, formatters
pip install pynvim

# Bash formatter, this will need latest golang on Ubuntu
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Lua formatter and linter
cargo install stylua
sudo luarocks install luacheck

# Python formatter, linter and lsp server
pip install autopep8
pip install flake8
pip install pyright

# Cmake formatter
pip install cmakelang

# Json formatter
sudo npm install -g fixjson

# Tree sitter
cargo install tree-sitter-cli

# Only for Ubuntu
if [ "$DISTRO" = "UBUNTU" ]; then
	cd $PROGRAMS_PATH

	# Rip grep
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
	sudo dpkg -i ripgrep_13.0.0_amd64.deb
	rm ripgrep_13.0.0_amd64.deb

	# Fd
	wget https://github.com/sharkdp/fd/releases/download/v8.3.1/fd_8.3.1_amd64.deb
	sudo dpkg -i fd_8.3.1_amd64.deb
	rm fd_8.3.1_amd64.deb

	# Clangformat, there was no way to just get it alone without whole
	# clang tooling, plus I had to do symlinks. Not so happy about this.
	wget https://apt.llvm.org/llvm.sh
	chmod +x llvm.sh
	sudo ./llvm.sh 13 all # Install all packages, version 13
	sudo ln -s /usr/bin/clang-format-13 /usr/bin/clang-format
	rm llvm.sh

	# Fix for stupid markdown thing
	sudo npm install -g tslib
	sudo npm install -g yarn
	sudo yarn add tslib
fi
