#!/usr/bin/env bash

. ./helper_functions.sh
check_distro
check_programs_path

#Common
install zsh

# Cargo was probably installed in the same session, source it to activate it
source $HOME/.cargo/env

# Install pure prompt theme, it is expected on a specific path by .zshrc
mkdir -p ~/.zsh/pure
mkdir -p ~/.zsh/antigen
git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure
curl -L git.io/antigen >~/.zsh/antigen/antigen.zsh

# Install various fonts
mkdir -p ~/.fonts

cd $PROGRAMS_PATH
git clone https://github.com/andreberg/Meslo-Font.git
cd Meslo-Font/dist/v1.2.1
unzip Meslo\ LG\ DZ\ v1.2.1.zip
mv Meslo\ LG\ DZ\ v1.2.1/*.ttf ~/.fonts
cd ../../../
rm -fr Meslo-Font

cd $PROGRAMS_PATH
wget https://github.com/googlefonts/noto-emoji/raw/main/fonts/NotoColorEmoji.ttf
mv NotoColorEmoji.ttf ~/.fonts

# Install SFMono font
cd $PROGRAMS_PATH
git clone https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git
cd SFMono-Nerd-Font-Ligaturized
mv *.otf ~/.fonts
cd ..
rm -fr SFMono-Nerd-Font-Ligaturized

# Material design icons
cd $PROGRAMS_PATH
git clone https://github.com/Templarian/MaterialDesign-Font.git
cd MaterialDesign-Font
cp *.ttf ~/.fonts
cd ..
rm -fr MaterialDesign-Font

# Eza tool, replacement for ls
cargo install eza

# Update new fonts
fc-cache -fv

if [ "$DISTRO" = "MANJARO" ]; then
	# Manjaro specific
	install alacritty
else
	# Ubuntu specific

	# Alacrity, fairly recent Rust compiler is warmly suggested
	install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

	cd $PROGRAMS_PATH
	git clone https://github.com/alacritty/alacritty.git
	cd alacritty
	cargo build --release

	# Desktop entry
	sudo cp target/release/alacritty /usr/local/bin
	sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
	sudo desktop-file-install extra/linux/Alacritty.desktop
	sudo update-desktop-database
	sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

	# Configure context menu in nautilus
	# Remove Open in Terminal option
	sudo apt purge nautilus-extension-gnome-terminal -y

	# Add Open in Alacritty option
	install python3-nautilus
    pip install nautilus-open-any-terminal --break-system-packages
	nautilus -q
	glib-compile-schemas ~/.local/share/glib-2.0/schemas/
	gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
	gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
	gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
	nautilus -q

fi

# Bye bye bash, hello zsh
chsh -s $(which zsh)
figlet "Done\!" | lolcat
figlet "Logout and log back in." | lolcat
