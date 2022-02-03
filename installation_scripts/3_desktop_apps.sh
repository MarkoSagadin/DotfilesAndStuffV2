#!/usr/bin/env bash

. ./helper_functions.sh
check_distro
check_programs_path

cd $PROGRAMS_PATH

# Ubuntu specific
# spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
install spotify-client

# otii
wget https://www.qoitech.com/downloads/otii_2.8.3.deb
sudo dpkg -i otii_2.8.3.deb
rm otii_2.8.3.deb

# nrf desktop
wget https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-Connect-for-Desktop/3-9-3/nrfconnect-3.9.3-x86_64.AppImage
sudo chmod +x nrfconnect-3.9.3-x86_64.AppImage

# nrf-command-line-tools-10
mkdir temp_folder
cd temp_folder
wget https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/10-15-0/nrf-command-line-tools-10.15.0_amd.zip
unzip nrf-command-line-tools-10.15.0_amd.zip
tar -xzvf nrf-command-line-tools*.tar.gz
sudo dpkg -i nrf-command-line-tools*.deb
sudo dpkg -i JLink_Linux*.deb
cd ..
rm -fr temp_folder
