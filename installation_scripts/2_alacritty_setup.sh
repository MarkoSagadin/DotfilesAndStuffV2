#!/usr/bin/env bash

. ./helper_functions.sh
check_distro
check_programs_path

# Ubuntu specific

# Alacrity, fairly recent Rust compiler is warmly suggested
install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

# Cargo was probably installed in the same session, source it to activate it
source $HOME/.cargo/env

cd $PROGRAMS_PATH
git clone https://github.com/alacritty/alacritty.git
cd alacritty
cargo build --release

# Desktop entry
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

# Install pure prompt theme, it is expected on a specific path by .zshrc
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

# Install Meslo font and source it
cd $PROGRAMS_PATH
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip
mkdir -p ~/.local/share/fonts/
mv $PROGRAMS_PATH/*.ttf ~/.local/share/fonts/
fc-cache -fv
rm Meslo.zip

# Configure context menu in nautilus
# Remove Open in Terminal option
sudo mv -vi /usr/lib/nautilus/extensions-3.0/libterminal-nautilus.so{,.bak}

# Add Open in Alacritty option
cd $PROGRAMS_PATH
pip install nautilus-open-any-terminal
nautilus -q
glib-compile-schemas ~/.local/share/glib-2.0/schemas/
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
nautilus -q

# Bye bye bash, hello zsh
chsh -s $(which zsh)
echo "Alacritty is ready! Close this terminal window and open new one with Alacritty."
