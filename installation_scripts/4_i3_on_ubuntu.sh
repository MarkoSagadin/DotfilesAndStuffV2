#!/usr/bin/env bash

. ./helper_functions.sh
check_distro
check_programs_path

cd $PROGRAMS_PATH

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
mkdir -p build && cd build
../configure
make -j16
sudo make install

# git clone https://github.com/i3-gnome/i3-gnome.git
# cd i3-gnome
# sudo make install

# install gnome-flashback
# gsettings set org.gnome.gnome-flashback desktop false
# gsettings set org.gnome.gnome-flashback root-background true

# Picom
cd $PROGRAMS_PATH
install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev \
	libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev \
	libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev \
	libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev \
	libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev \
	libevdev-dev uthash-dev libev-dev libx11-xcb-dev

git clone https://github.com/yshui/picom.git
cd picom
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
ninja -C build install

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
# Optional. This will install the polybar executable in /usr/local/bin
sudo make install

install rofi
install feh

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
git clone --depth=1 https://github.com/adi1090x/rofi.git
cd rofi
sudo chmod +x setup.sh
./setup.sh

install playerctl
install pavucontrol
install jq

cd $PROGRAMS_PATH
git clone https://github.com/noctuid/zscroll
cd zscroll
sudo python3 setup.py install
cd ..
rm -fr zscroll
