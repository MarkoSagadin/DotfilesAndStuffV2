#!/usr/bin/env bash

set -euo pipefail

. ./helper_functions.sh
check_distro

# Common

# Neovim tooling - linters, formatters
pip install pynvim --break-system-packages
pip install neovim --break-system-packages
sudo npm install -g tree-sitter-cli

if [ "$DISTRO" = "MANJARO" ]; then
    # Manjaro specific
    install neovim
else
    # Ubuntu specific
    NVIM_TAG="v0.10.2"
    curl -LO https://github.com/neovim/neovim/releases/download/$NVIM_TAG/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz
fi

echo ""
echo "##########################################"
echo "Stage 2 was installed"
echo "##########################################"
