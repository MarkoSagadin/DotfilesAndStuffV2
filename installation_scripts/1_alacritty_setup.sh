#!/usr/bin/env bash

. ./helper_functions.sh
check_distro
check_programs_path

install zsh

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
mkdir -p ~/.fonts
mv $PROGRAMS_PATH/*.ttf ~/fonts
rm Meslo.zip

# Install SFMono font
cd $PROGRAMS_PATH
git clone https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git
cd SFMono-Nerd-Font-Ligaturized
mkdir -p ~/.fonts
mv *.otf ~/.fonts
cd ..
rm -fr SFMono-Nerd-Font-Ligaturized

# Material design icons
cd $PROGRAMS_PATH
git clone https://github.com/Templarian/MaterialDesign-Font.git
cd MaterialDesign-Font
mkdir -p ~/.fonts
cp *.ttf ~/.fonts
cd ..
rm -fr MaterialDesign-Font

# Update new fonts
fc-cache -fv

# Configure context menu in nautilus
# Remove Open in Terminal option, this should be changed for manjaro!!!!!!!
sudo apt purge nautilus-extension-gnome-terminal -y

#Below is another way
#sudo mv -vi /usr/lib/x86_64-linux-gnu/nautilus/extensions-3.0/libterminal-nautilus.so{,.bak}

# Add Open in Alacritty option
cd $PROGRAMS_PATH
## FOR MANJARO
yay -S nautilus-open-any-terminal
## ONLY FOR UBUNTU
install python3-nautilus
pip install nautilus-open-any-terminal

#THIS is COMMON
nautilus -q
glib-compile-schemas ~/.local/share/glib-2.0/schemas/
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
nautilus -q

# Bye bye bash, hello zsh
chsh -s $(which zsh)
echo "Alacritty is ready! Logout and log back in."
