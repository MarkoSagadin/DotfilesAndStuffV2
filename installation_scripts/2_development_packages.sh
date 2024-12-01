#!/usr/bin/env bash

set -euo pipefail

. ./helper_functions.sh
check_distro

# Common

# Not related to development, but it makes life easier when learning new commands
pipx install tldr

# Neovim tooling - linters, formatters
pip install pynvim --break-system-packages
pip install neovim --break-system-packages

# # Install git-absorb
GIT_ABSORB_VERSION=0.6.16
GIT_ABSORB_NAME=git-absorb-${GIT_ABSORB_VERSION}-x86_64-unknown-linux-musl
GIT_ABSORB_URL=https://github.com/tummychow/git-absorb/releases/download
wget --output-document git-absorb.tar.gz \
    ${GIT_ABSORB_URL}/${GIT_ABSORB_VERSION}/${GIT_ABSORB_NAME}.tar.gz
tar zxfv git-absorb.tar.gz
sudo cp ${GIT_ABSORB_NAME}/git-absorb /usr/bin/
rm -rf ${GIT_ABSORB_NAME} git-absorb.tar.gz

if [ "$DISTRO" = "MANJARO" ]; then
    # Manjaro specific
    install neovim ripgrep fd clang
    installyay diff-so-fancy
else
    # Ubuntu specific
    # Install dependencies common to all packages
    sudo add-apt-repository ppa:aos1/diff-so-fancy -y
    sudo apt-get update
    install diff-so-fancy ripgrep fd-find

    NVIM_TAG="v0.10.2"
    curl -LO https://github.com/neovim/neovim/releases/download/$NVIM_TAG/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz

    # Clangformat, there was no way to just get it alone without whole
    # clang tooling, Not so happy about this, but now I accepted this.
    wget https://apt.llvm.org/llvm.sh
    chmod +x llvm.sh
    sudo ./llvm.sh 18 all # Install all packages, version 18
    rm llvm.sh
fi
