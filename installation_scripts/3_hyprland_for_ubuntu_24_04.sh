#!/usr/bin/env bash

set -euo pipefail

. ./helper_functions.sh
check_distro

if [ "$DISTRO" = "MANJARO" ]; then
    echo "This script is only works on Ubuntu"
    exit
fi

SCRIPT_DIR=$(realpath $(dirname $0))

# Delete the tmp dir first, this makes this script easier to debug
rm -fr ~/tmp
mkdir -p ~/tmp
cd ~/tmp

# Source cargo, it was installed at some point
source "$HOME/.cargo/env"

# Source go, it was installed at some point
export PATH=$PATH:/usr/local/go/bin

# Ubuntu specific
install meson wget build-essential ninja-build cmake-extras cmake automake gawk gettext gir1.2-graphene-1.0 glslang-tools gobject-introspection hwdata jq gettext-base fontconfig libfontconfig-dev libffi-dev libxml2-dev libdrm-dev libxkbcommon-x11-dev libxkbregistry-dev libxkbcommon-dev libpixman-1-dev libudev-dev libseat-dev seatd scdoc libxcb-dri3-dev libegl-dev libgles2 libegl1-mesa-dev glslang-tools libinput-bin libinput-dev libxcb-composite0-dev libavutil-dev libavcodec-dev libavformat-dev libxcb-ewmh2 libxcb-ewmh-dev libxcb-present-dev libxcb-icccm4-dev libxcb-render-util0-dev libxcb-res0-dev libxcb-xinput-dev libtomlplusplus3 libcairo2-dev libgbm-dev libglvnd-core-dev libglvnd-dev libjpeg-turbo8-dev libpam0g-dev libpango1.0-dev libspa-0.2-dev libwebp-dev libxcb-xkb-dev libxkbcommon-dev xdg-desktop-portal xdg-desktop-portal-gtk xwayland openssl psmisc python3-mako python3-markdown python3-markupsafe python3-yaml python3-pyquery qt6-base-dev spirv-tools vulkan-validationlayers libzip-dev libtomlplusplus-dev librsvg2-dev libxcb-util-dev libmagic-dev libpugixml-dev libdbus-1-dev graphviz doxygen xsltproc xmlto xcb-proto xutils-dev libcap-dev libdisplay-info-dev libliftoff-dev libdrm-dev xdg-desktop-portal-wlr

# Add deb-src to the ubuntu.sources file so that any later apt build-dep
# command works.
sudo sed -Ei "s/(^Types: deb$)/\1 deb-src/g" /etc/apt/sources.list.d/ubuntu.sources
sudo apt update

sudo apt build-dep wlroots -y

# Latest compilers are a dependency of hyprland
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
install gcc-14 g++-14
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 14 --slave /usr/bin/g++ g++ /usr/bin/g++-14

# Dependency of hyprland
xcb_tag="fba5e519e519524c61872948c9b883d6412201ca"
git clone https://salsa.debian.org/debian/xcb-util-errors.git
cd xcb-util-errors
git checkout $xcb_tag
./configure
make
sudo make install
cd ..

wayland_tag="1.23.1"
git clone -b $wayland_tag https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
meson setup --prefix=/usr build/
sudo ninja -C build/ install
cd ..

# WARN: Installing this is easy, configuring impossible. It is better to use pipewire provided by
# the system.
# pipe_tag="1.4.0"
# git t clone -b $pipe_tag https://github.com/pipewire/pipewire.git
# cd pipewire
# meson setup build
# son configure build
# son compile -C build
# sudo meson install -C build
# cd ..

sdbus_tag="v2.1.0"
git clone -b $sdbus_tag https://github.com/kistler-group/sdbus-cpp.git
cd sdbus-cpp
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DSDBUSCPP_BUILD_LIBSYSTEMD=ON
cmake --build .
sudo cmake --build . --target install
cd ..

wayproto_tag="1.41"
git clone --recursive -b $wayproto_tag https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
meson setup --prefix=/usr build
sudo ninja -C build install
cd ..

hyprutils_tag="v0.5.1"
git clone -b $hyprutils_tag https://github.com/hyprwm/hyprutils.git
cd hyprutils/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
sudo cmake --install build
cd ..

lang_tag="v0.6.0"
git clone --recursive -b $lang_tag https://github.com/hyprwm/hyprlang.git
cd hyprlang
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j$(nproc 2>/dev/null || getconf NPROCESSORS_CONF)
sudo cmake --install ./build
cd ..

cursor_tag="v0.1.11"
git clone --recursive -b $cursor_tag https://github.com/hyprwm/hyprcursor.git
cd hyprcursor
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf NPROCESSORS_CONF)
sudo cmake --install ./build
cd ..

scanner_tag="v0.4.4"
git clone -b $scanner_tag https://github.com/hyprwm/hyprwayland-scanner.git
cd hyprwayland-scanner
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
cmake --build build -j $(nproc)
sudo cmake --install build
cd ..

sudo apt build-dep libinput -y
libinput_tag="1.27.1"
git clone -b $libinput_tag https://gitlab.freedesktop.org/libinput/libinput.git
cd libinput
meson setup --prefix=/usr build/
ninja -C build/
sudo ninja -C build install
cd ..

protocols_tag="v0.6.2"
git clone --recursive -b $protocols_tag https://github.com/hyprwm/hyprland-protocols.git
cd hyprland-protocols
meson setup --prefix=/usr build/
sudo ninja -C build/ install
cd ..

aquamarine_tag="v0.7.2"
git clone -b $aquamarine_tag https://github.com/hyprwm/aquamarine.git
cd aquamarine
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf NPROCESSORS_CONF)
sudo cmake --install ./build
cd ..

# Needed by hyprgraphics
libspng="v0.7.4"
git clone -b $libspng https://github.com/randy408/libspng.git
cd libspng/
meson build --buildtype=release
ninja -C build/
sudo ninja -C build/ install
cd ..

# Needed by hyprland from v0.47.2
hyprgraphics_tag="v0.1.2"
git clone -b $hyprgraphics_tag https://github.com/hyprwm/hyprgraphics.git
cd hyprgraphics/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf NPROCESSORS_CONF)
sudo cmake --install build
cd ..

# Needed by re2
abseil_tag="20250127.0"
git clone -b $abseil_tag https://github.com/abseil/abseil-cpp.git
cd abseil-cpp/
cmake -B build -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_SHARED_LIBS=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON
sudo cmake --build build --target install
cd ..

# Needed by hyprland from v0.47.2
re2_tag="2024-07-02"
git clone -b $re2_tag https://github.com/google/re2.git
cd re2/
make -j16
sudo make install
cd ..

#hyprland_tag="v0.45.2"
hyprland_tag="v0.47.2"
git clone --recursive -b $hyprland_tag https://github.com/hyprwm/Hyprland.git
cd Hyprland
make all
sudo make install
cd ..

idle_tag="v0.1.5"
git clone --recursive -b $idle_tag https://github.com/hyprwm/hypridle.git
cd hypridle
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
cmake --build ./build --config Release --target hypridle -j$(nproc 2>/dev/null || getconf NPROCESSORS_CONF)
sudo cmake --install ./build
cd ..

# lock_tag="v0.5.0"
lock_tag="v0.7.0"
git clone --recursive -b $lock_tag https://github.com/hyprwm/hyprlock.git
cd hyprlock
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
cmake --build ./build --config Release --target hyprlock -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
sudo cmake --install build
cd ..

# WARN: not needed, xdg-desktop-portal-wlr works well enough
# xdph_tag="v1.3.8" # Doesn't work
# xdph_tag="v1.3.9"
# git clone --recursive -b $xdph_tag https://github.com/hyprwm/xdg-desktop-portal-hyprland.git
# cd xdg-desktop-portal-hyprland
# cmake -DCMAKE_INSTALL_LIBEXECDIR=/usr/lib -DCMAKE_INSTALL_PREFIX=/usr -B build
# cmake --build build
# sudo cmake --install build
# cd ..

# Various things
install feh playerctl pavucontrol pamixer jq brightnessctl gnome-system-monitor cliphist gvfs gvfs-backends imagemagick pavucontrol polkit-kde-agent-1 qt5ct qt5-style-kvantum qt5-style-kvantum-themes qt6ct sway-notification-center wl-clipboard wlogout xdg-user-dirs xdg-utils yad policykit-desktop-privileges phinger-cursor-theme libplayerctl-dev

## Make brightnessctl work
sudo chmod +s $(which brightnessctl)

sudo usermod -aG input "$(whoami)"

# Thunar things
install ffmpegthumbnailer file-roller thunar thunar-volman tumbler thunar-archive-plugin xarchiver

# SDDM things
install sddm qml-module-qtgraphicaleffects qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-extras qml-module-qtquick-layouts

sudo systemctl disable gdm
sudo systemctl enable sddm

cd $SCRIPT_DIR
# Download, set theme and wallpaper
tar -xf support_scripts/sugar-candy.tar.gz
sudo touch "/etc/sddm.conf"
sudo mkdir -p /usr/share/sddm/themes
sudo mv sugar-candy /usr/share/sddm/themes/
sudo cp ../assets/sddm-wallpaper.jpg /usr/share/sddm/themes/sugar-candy

theme_conf=/usr/share/sddm/themes/sugar-candy/theme.conf
sudo sed -i 's/^Background="[^"]*"/Background="sddm-wallpaper.jpg"/' $theme_conf
sudo sed -i 's/^ScreenWidth="[^"]*"/ScreenWidth="1920"/' $theme_conf
sudo sed -i 's/^ScreenHeight="[^"]*"/ScreenHeight="1080"/' $theme_conf

echo "[Theme]" | sudo tee -a /etc/sddm.conf >/dev/null
echo "Current=sugar-candy" | sudo tee -a /etc/sddm.conf >/dev/null

#Go back to tmp dir
cd ~/tmp

# rofi
install libpango1.0-dev libstartup-notification0-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-xkb-dev libxcb-keysyms1-dev flex libxcb-cursor-dev libxcb-xinerama0-dev

rofi_tag="1.7.8+wayland1"
git clone -b ${rofi_tag} --recursive https://github.com/lbonn/rofi.git
cd rofi
meson setup build
ninja -C build
sudo ninja -C build install
cd ..

# Bluetooth
install bluez blueman
sudo systemctl enable --now bluetooth.service

install libgtk-3-dev libcairo2-dev libglib2.0-bin
nwg_tag="v1.0.2"
git clone --recursive -b "$nwg_tag" --depth 1 https://github.com/nwg-piotr/nwg-look.git
cd nwg-look
make build
sudo make install
cd ..

wallust_tag="3.2.0"
wallust_name="wallust-${wallust_tag}-x86_64-unknown-linux-musl-with-assets"
wget https://codeberg.org/explosion-mental/wallust/releases/download/${wallust_tag}/${wallust_name}.tar.gz
tar -xf ${wallust_name}.tar.gz
sudo cp ${wallust_name}/man/*.1 /usr/local/share/man/man1
sudo cp ${wallust_name}/wallust /usr/bin/

install libgtkmm-3.0-dev libpulse-dev libnl-3-dev libnl-genl-3-dev
waybar_tag="0.12.0"
git clone -b $waybar_tag https://github.com/Alexays/Waybar
cd Waybar
meson setup build
ninja -C build
sudo ninja -C build install
cd ..

# Clipboard
install copyq
wget https://raw.githubusercontent.com/janza/wl-clipboard-history/refs/heads/master/wl-clipboard-history
sudo mv wl-clipboard-history /usr/bin/

# TODO: Below was needed to get network running on Ubuntu Server
# Desktop version doesn need it. Also, not everything was working with below
# setup so test in the future if you have to.
# Make all netowork devices (wifi adapters) to be managed by NetworkManager
# install network-manager
# NETPLAN_FILE=/etc/netplan/10-manage-devices-init.yaml
# sudo rm $NETPLAN_FILE
# sudo touch $NETPLAN_FILE
# echo "network:" | sudo tee -a $NETPLAN_FILE > /dev/null
# echo "    renderer: NetworkManager" | sudo tee -a $NETPLAN_FILE > /dev/null
# sudo chmod 600 $NETPLAN_FILE
# sudo netplan apply
# sudo systemctl restart NetworkManager.service

# Install wallpaper daemon
install liblz4-dev
swww_tag="v0.9.5"
git clone -b $swww_tag https://github.com/LGFae/swww
cd swww
cargo build --release
sudo mv target/release/swww /usr/bin
sudo mv target/release/swww-daemon /usr/bin
cd ..

# Redshift (blue light blocker) for wayland
wlsunset_tag="0.4.0"
git clone -b $wlsunset_tag https://git.sr.ht/~kennylevinsen/wlsunset
cd wlsunset
meson build
ninja -C build
sudo ninja -C build install
cd ..

cd ~
rm -fr ~/tmp

# Prepare colors and set the first default wallpaper
wallust run -s $SCRIPT_DIR/../assets/sddm-wallpaper.jpg
swww-daemon &
swww img $SCRIPT_DIR/../assets/sddm-wallpaper.jpg

echo ""
echo "Stage 4 done, you can reboot system now."
