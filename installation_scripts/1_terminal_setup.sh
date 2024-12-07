#!/usr/bin/env bash

set -euo pipefail

. ./helper_functions.sh
check_distro

#Common
# Cargo was probably installed in the same session, source it to activate it
source $HOME/.cargo/env

install zsh

# Install tmux plugin manager and install all plugins, this file should kept
# out of git.
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Install pure prompt theme, it is expected on a specific path by .zshrc
mkdir -p ~/.zsh/pure
mkdir -p ~/.zsh/antigen
git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure
curl -L git.io/antigen >~/.zsh/antigen/antigen.zsh

# Install various fonts
mkdir -p ~/.fonts

mkdir -p ~/tmp
cd ~/tmp

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Meslo.zip
unzip Meslo.zip -d ~/.fonts
rm -fr Meslo.zip

wget https://github.com/googlefonts/noto-emoji/raw/main/fonts/NotoColorEmoji.ttf
mv NotoColorEmoji.ttf ~/.fonts

# Install SFMono font
git clone https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git
cd SFMono-Nerd-Font-Ligaturized
mv *.otf ~/.fonts
cd ..  rm -fr SFMono-Nerd-Font-Ligaturized

# Material design icons
git clone https://github.com/Templarian/MaterialDesign-Font.git
cd MaterialDesign-Font
cp *.ttf ~/.fonts
cd ..
rm -fr MaterialDesign-Font

# Eza tool, replacement for ls
cargo install eza

# Update new fonts
fc-cache -fv

# Not related to development, but it makes life easier when learning new commands
pipx install tldr

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
    install alacritty ripgrep fd clang
    installyay diff-so-fancy
else
    # Ubuntu specific
    sudo add-apt-repository ppa:aos1/diff-so-fancy -y
    sudo apt-get update
    install diff-so-fancy ripgrep fd-find

    install pkg-config libfontconfig1-dev desktop-file-utils
    cargo install alacritty

    # Add desktop entry and terminal info
    git clone https://github.com/alacritty/alacritty.git
    cd alacritty
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
    cd ..

    # TODO: move this into a separate file
    # # Configure context menu in nautilus
    # # Remove Open in Terminal option
    # sudo apt purge nautilus-extension-gnome-terminal -y

    # # Add Open in Alacritty option
    # install python3-nautilus
    # pip install nautilus-open-any-terminal --break-system-packages
    # nautilus -q
    # glib-compile-schemas ~/.local/share/glib-2.0/schemas/
    # gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
    # gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
    # gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
    # nautilus -q
    # TODO: Above can not be done on a ubuntu server
fi

cd ~/tmp
rm -fr ~/tmp

# Bye bye bash, hello zsh
chsh -s $(which zsh)

echo ""
echo "############################################################"
echo "Stage 1 was installed"
echo ""
echo "Logout and log back in for the shell changes to take affect,"
echo "or continue with the rest of the installation scripts."
echo "############################################################"
