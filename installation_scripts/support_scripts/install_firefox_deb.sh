#!/usr/bin/env bash

set -euo pipefail

firefox_version() {
	dpkg -l firefox | awk '/ii/ {print $3}' | sed 's/[~+-].*//'
}

# Remove Firefox Snap Package (Ubuntu). Consider disabling Snaps since Ubuntu may reinstall Snap.
rm_firefox_snap() {
	if snap list | grep -qw firefox; then
		printf "Firefox version installed: %s\n" "$(snap list | awk '/Firefox/ {print $2}')"
		sudo snap remove --purge firefox
	else
		printf "Firefox is not installed as a Snap.\n"
	fi
}

make_preference_file() {
	# Preference file to prioritize packages from Mozilla repository
	echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla.pref
}


mozilla_deb_install() {
	local asc_file keyrings_d key_url list_url mozilla_list
	keyrings_d="/etc/apt/keyrings"
	asc_file="packages.mozilla.org.asc"
	key_url="https://packages.mozilla.org/apt/repo-signing-key.gpg"
	list_url="https://packages.mozilla.org/apt"
	mozilla_list="/etc/apt/sources.list.d/mozilla.list"

	printf "Installing the Mozilla Firefox DEB package...\n"
	# Import Mozilla APT repository keys
	[[ -d "$keyrings_d" ]] || sudo install -d -m 0755 "$keyrings_d"
	printf "Importing Mozilla APT repository keys...\n"
	wget -q "$key_url" -O- | sudo tee "$keyrings_d/$asc_file" > /dev/null

	make_preference_file

	# Add Mozilla APT repository to sources list
	printf "Adding Mozilla APT repository to sources list...\n"
	echo "deb [signed-by=$keyrings_d/$asc_file] $list_url mozilla main" | sudo tee -a "$mozilla_list" > /dev/null

	# Update package list and install Firefox .deb package
	sudo apt-get update && sudo apt-get install -y firefox
	printf "%s installed.\n" "$(firefox_version)"
}

echo "HEREERE"

# Check if the Mozilla package is already installed
#dpkg -l firefox | grep -q 'build' && echo "Mozilla Firefox DEB package ($(firefox_version)) is already installed."; exit;

echo "HEREERE"

# THIS IS MISSING
# exists snap && 
    
# rm_firefox_snap

mozilla_deb_install


## Install Mozilla DEB package
#if yes_or_no "Install Mozilla Firefox DEB package?"; then
#	mozilla_deb_install
#else
#	printf "Operation canceled. No action taken.\n"
#fi
