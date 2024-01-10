#!/usr/bin/env bash

. ./helper_functions.sh
check_distro
check_programs_path

cd $PROGRAMS_PATH

install feh playerctl pavucontrol jq brightnessctl

# Enable writing to brightness file, maybe a bit of a overkill
backend=$(ls -1 /sys/class/backlight/)
sudo chmod 777 /sys/class/backlight/$backend/brightness

cd $PROGRAMS_PATH
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme
./install.sh -c dark -c light
cd ..
rm -fr WhiteSur-gtk-theme

cd $PROGRAMS_PATH
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme
./install.sh
cd ..
rm -fr WhiteSur-icon-theme

# Install cronie, for scheduling
git clone https://github.com/cronie-crond/cronie
cd cronie
git checkout cronie-1.7.0
./autogen.sh
./configure
make
sudo make install
cd ..
rm -fr cronie

# Needed for notification center
pip install notify-send.py

if [ "$DISTRO" = "MANJARO" ]; then
	install dunst bluez bluez-utils
	installyay deadd-notification-center-bin

	# Remove some packages as they are in conflict with desired ones
	remove manjaro-i3-settings pcmanfm palemoon-bin
	installyay polybar zscroll thunar picom-git
	install pulseaudio pulseaudio-bluetooth

	# Enable bluetooth, sometimes is not
	echo "AutoEnable=true" | sudo tee -a /etc/bluetooth/main.conf
	sudo systemctl start bluetooth.service
	sudo systemctl enable bluetooth.service

	# Prepare for a different desktop manager
	installyay sddm chili-sddm-theme
	sudo systemctl enable sddm.service
else
	# i3-gaps
	install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
		libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
		libstartup-notification0-dev libxcb-randr0-dev \
		libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
		libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
		autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev meson

	sudo add-apt-repository ppa:regolith-linux/release
	sudo apt update
	install i3-gaps

	git clone https://www.github.com/resloved/i3 i3-gaps-rounded
	cd i3-gaps-rounded
	autoconf -fi
	mkdir -p build && cd build
	../configure
	make -j16
	sudo make install
	cd ..
	rm -fr i3-gaps-rounded

	# Picom
	cd $PROGRAMS_PATH
	install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev \
		libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev \
		libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev \
		libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev \
		libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev \
		libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-dpms0-dev

	git clone https://github.com/yshui/picom
	cd picom
	git submodule update --init --recursive
	meson --buildtype=release . build
	ninja -C build
	ninja -C build install
	cd ..
	rm -fr picom

	install build-essential git cmake cmake-data pkg-config python3-sphinx python3-packaging libuv1-dev libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev

	install libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev

	# Polybar
	cd $PROGRAMS_PATH
	git clone --recursive https://github.com/polybar/polybar
	cd polybar
	mkdir build
	cd build
	cmake ..
	make -j$(nproc)
	sudo make install
	cd ..
	rm -fr polybar

	cd $PROGRAMS_PATH
	git clone https://github.com/FedeDP/libmodule.git
	cd libmodule
	mkdir build
	cd build
	cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib ../
	make
	sudo make install
	cd ../..
	rm -fr libmodule

	install build-essential pkg-config cmake libsystemd-dev libxrandr-dev libxext-dev policykit-1 libpolkit-gobject-1-dev libjpeg-dev libusb-dev libwayland-dev libdrm-dev libddcutil-dev libdbus-1-dev libudev-dev libusb-1.0-0-dev
	cd $PROGRAMS_PATH
	git clone https://github.com/FedeDP/Clightd.git
	cd Clightd
	git checkout 5.5
	mkdir build
	cd build
	cmake \
		-G "Unix Makefiles" \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DCMAKE_BUILD_TYPE="Release" \
		-DENABLE_DDC=0 -DENABLE_GAMMA=1 -DENABLE_DPMS=1 -DENABLE_SCREEN=1 -DENABLE_YOCTOLIGHT=1 \
		..
	make
	sudo make install
	cd ../..
	rm -fr Clightd

	cd $PROGRAMS_PATH
	git clone https://github.com/FedeDP/Clight.git
	cd Clight
	git checkout 4.8
	mkdir build
	cd build
	cmake \
		-G "Unix Makefiles" \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DCMAKE_BUILD_TYPE="Release" \
		..
	make
	sudo make install
	cd ../..
	rm -fr Clight

	cd $PROGRAMS_PATH
	git clone https://github.com/noctuid/zscroll
	cd zscroll
	sudo python3 setup.py install
	cd ..
	rm -fr zscroll

	install libdbus-1-dev libx11-dev libxinerama-dev libxrandr-dev libxss-dev \
		libglib2.0-dev libgtk-3-dev libxdg-basedir-dev libnotify-dev

	# Needed for linux_notification_center
	install gobject-introspection haskell-stack libgirepository1.0-dev

	# This will take long
	git clone https://github.com/phuhl/linux_notification_center.git
	cd linux_notification_center
	wget https://github.com/phuhl/linux_notification_center/releases/download/2.1.1/deadd-notification-center
	mkdir -p .out
	mv deadd-notification-center .out
	make
	sudo make install
	cd ..
	rm -fr linux_notification_center

	install policykit-desktop-privileges policykit-1-gnome
	install libpangocairo-1.0-0 flex

	cd $PROGRAMS_PATH
	git clone --recursive https://github.com/davatorium/rofi.git
	cd rofi
	git checkout 1.7.3
	meson setup build
	ninja -C build
	ninja -C build install
	cd ..
	rm -fr rofi

	install qml-module-qtquick-controls qml-module-qtgraphicaleffects

	cd $PROGRAMS_PATH
	install sddm qt5-default
	git clone https://github.com/MarianArlt/sddm-chili.git
	sudo mv sddm-chili chili
	sudo mv chili /usr/share/sddm/themes/
	sudo cp ../wallpapers/big-sur.jpg /usr/share/sddm/themes/chili/asseet/background.jpg

	echo "[Theme]" | sudo tee -a /etc/sddm.conf
	echo "Current=chili" | sudo tee -a /etc/sddm.conf

	cd $PROGRAMS_PATH
	git clone https://github.com/phillipberndt/autorandr.git
	cd autorandr
	sudo make install
	cd ..
	rm -fr autorandr
fi

figlet "AWW YEAH, DONE!" | lolcat
echo "Only thing left to do is to set login wallpaper"
echo "You can do this with below commmand:"
echo ""
echo "cp <path to wallpaper> /usr/share/sddm/themes/chili/asseet/background.jpg"
echo ""
