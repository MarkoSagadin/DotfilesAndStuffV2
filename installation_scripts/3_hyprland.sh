#!/usr/bin/env bash

set -euo pipefail

. ./helper_functions.sh
check_distro

mkdir -p ~/tmp
cd ~/tmp

# Source cargo, it was installed at some point
source "$HOME/.cargo/env"

if [ "$DISTRO" = "MANJARO" ]; then
    installyay spotify slack-desktop otii nrf5x-command-line-tools nrfconnect-appimage

else
    # Ubuntu specific
    install meson wget build-essential ninja-build cmake-extras cmake gettext gettext-base fontconfig libfontconfig-dev libffi-dev libxml2-dev libdrm-dev libxkbcommon-x11-dev libxkbregistry-dev libxkbcommon-dev libpixman-1-dev libudev-dev libseat-dev seatd libxcb-dri3-dev libegl-dev libgles2 libegl1-mesa-dev glslang-tools libinput-bin libinput-dev libxcb-composite0-dev libavutil-dev libavcodec-dev libavformat-dev libxcb-ewmh2 libxcb-ewmh-dev libxcb-present-dev libxcb-icccm4-dev libxcb-render-util0-dev libxcb-res0-dev libxcb-xinput-dev libtomlplusplus3 hyprwayland-scanner libcairo2-dev libgbm-dev libglvnd-core-dev libglvnd-dev libjpeg-turbo-dev libpam0g-dev libpango1.0-dev libpipewire-0.3-dev libspa-0.2-dev libwayland-dev libwebp-dev libxcb-xkb-dev libxkbcommon-dev wayland-protocols xdg-desktop-portal xdg-desktop-portal-gtk xwayland

    sudo apt build-dep wlroots

    lang_tag="v0.5.2"
    git clone --recursive -b $lang_tag https://github.com/hyprwm/hyprlang.git
    cd hyprlang
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target hyprlang -j$(nproc 2>/dev/null || getconf NPROCESSORS_CONF)
    sudo cmake --install ./build
    cd ..

    cursor_tag="v0.1.9"

    git clone --recursive -b $cursor_tag https://github.com/hyprwm/hyprcursor.git
    cd hyprcursor
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf NPROCESSORS_CONF)
    sudo cmake --install ./build
    cd ..

    hyprland_tag="v0.39.1"
    git clone --recursive -b $hyprland_tag https://github.com/hyprwm/Hyprland.git
    cd Hyprland
    make all
    sudo make install
    cd ..

    idle_tag="v0.1.2"
    git clone --recursive -b $idle_tag https://github.com/hyprwm/hypridle.git
    cd hypridle
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
    cmake --build ./build --config Release --target hypridle -j$(nproc 2>/dev/null || getconf NPROCESSORS_CONF)
    sudo cmake --install ./build
    cd ..

    lock_tag="v0.3.0"
    git clone --recursive -b $lock_tag https://github.com/hyprwm/hyprlock.git
    cd hyprlock
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
    cmake --build ./build --config Release --target hyprlock -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
    sudo cmake --install build
    cd ..

    xdph_tag="v1.3.2"
    git clone --recursive -b $xdph_tag https://github.com/hyprwm/xdg-desktop-portal-hyprland.git
    cd xdg-desktop-portal-hyprland
    cmake -DCMAKE_INSTALL_LIBEXECDIR=/usr/lib -DCMAKE_INSTALL_PREFIX=/usr -B build
    cmake --build build
    sudo cmake --install build
    cd ..

    scanner_tag="v0.4.2"
    git clone -b $scanner_tag https://github.com/hyprwm/hyprwayland-scanner.git
    cd hyprwayland-scanner
    cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
    cmake --build build -j $(nproc)
    sudo cmake --install build
    cd ..

    hyprutils_tag="v0.2.6"
    git clone -b $hyprutils_tag https://github.com/hyprwm/hyprutils.git
    cd hyprutils/
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
    sudo cmake --install build
    cd ..

    paper_tag="v0.7.1"
    git clone -b $paper_tag https://github.com/hyprwm/hyprpaper.git
    cd hyprpaper
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target hyprpaper -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
    sudo cmake --install ./build

    # Various things
    install feh playerctl pavucontrol pamixer jq brightnessctl gnome-system-monitor cliphist gvfs gvfs-backends imagemagick pavucontrol polkit-kde-agent-1 qt5ct qt5-style-kvantum qt5-style-kvantum-themes qt6ct sway-notification-center waybar wl-clipboard wlogout xdg-user-dirs xdg-utils yad policykit-desktop-privileges qt5-default, phinger-cursor-theme libplayerctl-dev

    ## making brightnessctl work
    sudo chmod +s $(which brightnessctl)

    sudo groupadd input
    sudo usermod -aG input "$(whoami)"

    # Thunar things
    install ffmpegthumbnailer file-roller thunar thunar-volman tumbler thunar-archive-plugin xarchiver

    # SDDM things
    install sddm qml-module-qtgraphicaleffects qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-extras qml-module-qtquick-layouts

    sudo systemctl enable sddm

    sddm_conf_dir=/etc/sddm.conf.d
    wayland_sessions_dir=/usr/share/wayland-sessions
    sudo mkdir -p "$sddm_conf_dir"
    sudo cp assets/hyprland.desktop "$wayland_sessions_dir/"

    git clone https://github.com/Keyitdev/sddm-astronaut-theme.git
    sudo mkdir -p /usr/share/sddm/themes
    sudo mv sddm-astronaut-theme /usr/share/sddm/themes/

    sudo tee -a "$sddm_conf_dir/theme.conf.user" > /dev/null <<EOT
    [Theme]
    Current=sddm-astronaut-theme
    FullBlur="true"
    BlurMax="64"
    Blur="1.0"
    EOT

    # rofi
    install libpango1.0-dev libstartup-notification0-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-xkb-dev libxcb-keysyms1-dev flex

    rofi_tag="1.7.5+wayland3"
    git clone -b ${rofi_tag} --recursive https://github.com/lbonn/rofi.git
    cd rofi
    meson setup build
    ninja -C build
    sudo ninja -C build install
    cd ..

    # Bluetooth
    install bluez blueman
    sudo systemctl enable --now bluetooth.service

    # nwg-look
    install libgtk-3-dev libcairo2-dev libglib2.0-bin
    nwg_tag="v0.2.7"
    git clone --recursive -b "$nwg_tag" --depth 1 https://github.com/nwg-piotr/nwg-look.git
    cd nwg-look
    make build
    sudo make install
    cd ..

    wallust_tag="3.1.0"
    wallust_name="wallust-${wallust_tag}-x86_64-unknown-linux-musl-with-assets"
    wget https://codeberg.org/explosion-mental/wallust/releases/download/${wallust_tag}/${wallust_name}.tar.gz
    tar -xf ${wallust_name}.tar.gz
    sudo cp ${wallust_name}/man/*.1 /usr/local/share/man/man1
    sudo cp ${wallust_name}/wallust /usr/bin/
    rm -fr ${wallust_name}*

    # Clipboard
    install copyq
    wget https://raw.githubusercontent.com/janza/wl-clipboard-history/refs/heads/master/wl-clipboard-history
    sudo mv wl-clipboard-history /usr/bin/

    # Make all netowork devices (wifi adapters) to be managed by NetworkManager
    NETPLAN_FILE=/etc/netplan/10-manage-devices-init.yaml
    touch $NETPLAN_FILE
    sudo tee -a $NETPLAN_FILE > /dev/null <<EOT
    network:
        renderer: NetworkManager
    EOT
    sudo chmod 600 $NETPLAN_FILE
    sudo net apply
    sudo systemctl restart NetworkManager.service

    # Install wallpaper daemon
    install liblz4-dev
    swww_tag="v0.9.5"
    git clone -b $swww_tag https://github.com/LGFae/swww
    cd swww
    cargo build --release
    sudo mv target/release/swww /usr/bin
    sudo mv target/release/swww-daemon /usr/bin
    cd ..
    rm -fr swww

    # Redshift (blue light blocker) for wayland
    wlsunset_tag="0.4.0"
    git clone -b $wlsunset_tag https://git.sr.ht/~kennylevinsen/wlsunset
    cd wlsunset
    meson build
    ninja -C build
    sudo ninja -C build install
    cd ..
    rm -fr wlsunset
fi


cd ..
rm -fr ~/tmp
