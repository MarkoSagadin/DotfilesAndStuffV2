#!/usr/bin/env bash

set -euo pipefail

. ./helper_functions.sh
check_distro

mkdir -p ~/tmp
cd ~/tmp

if [ "$DISTRO" = "MANJARO" ]; then
    installyay spotify slack-desktop otii nrf5x-command-line-tools nrfconnect-appimage

else
    # Ubuntu specific
    # spotify
    # If this dir is not present then spotify can't be run from rofi, only from terminal.
    sudo mkdir /usr/share/desktop-directories/

    curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update
    install spotify-client

    # nrf desktop
    # wget https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-connect-for-desktop/5-1-0/nrfconnect-5.1.0-x86_64.appimage
    # chmod +x nrfconnect-*
fi

cd ..
rm -fr ~/tmp
