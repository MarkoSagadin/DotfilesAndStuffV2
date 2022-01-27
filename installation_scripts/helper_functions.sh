#!/usr/bin/env bash

SUPPORTED_DISTROS=("UBUNTU" "MANJARO")

# Usage: check_distro
# Variable DISTRO should be exported before calling this function.
# Variable DISTRO should be either set to MANJARO or UBUNTU
# This function should be called first before calling any other function from this file
function check_distro {
	# -z checks if the given string has lenght of one
	if [ -z "$DISTRO" ]; then
		echo "DISTRO variable was not exported before calling this script!"
		echo "This can be done with: "
		echo ""
		echo "    export DISTRO=<supported_distro>"
		echo ""
		echo "Supported distros are:"
		for SUPPORTED_DISTRO in ${SUPPORTED_DISTROS[@]}; do
			echo " - $SUPPORTED_DISTRO"
		done
		exit
	fi

	if [[ ! " ${SUPPORTED_DISTROS[*]} " =~ " ${DISTRO} " ]]; then
		echo "Given distro $DISTRO is not supported!"
		echo "Supported distros are:"
		for SUPPORTED_DISTRO in ${SUPPORTED_DISTROS[@]}; do
			echo " - $SUPPORTED_DISTRO"
		done
		exit
	fi
}

# Usage: check_programs_path
# Variable PROGRAMS_PATH should be exported before calling this function.
# It should be set to a an absolute path where all packages built from source
# will be stored.
# If the folder does not yet exists, it will be created.
function check_programs_path {
	# -z checks if the given string has lenght of one
	if [ -z "$PROGRAMS_PATH" ]; then
		echo "PROGRAMS_PATH variable was not exported before calling this script!"
		echo "This can be done with: "
		echo ""
		echo "    export PROGRAMS_PATH=<programs_directory>"
		echo ""
		echo ""
		echo "It should be set to a an absolute path where all packages built from source will be stored."
		echo "If the folder does not yet exists, it will be created."
		exit
	fi
	mkdir -p $PROGRAMS_PATH
}

# Usage: install <package_name> <more_packages>
# It expects that the variable 'DISTRO' is set
function install {
	echo "Installing: $* ..."
	if [ "$DISTRO" = "MANJARO" ]; then
		sudo pacman -S --noconfirm $*
	elif [ "$DISTRO" = "UBUNTU" ]; then
		sudo apt install $* -y
	else
		echo "Ops, something went wrong, time to debug!"
		exit
	fi
}

# Usage: installyay <package_name>
# It expects that the variable 'system' is set
function installyay {
	if [ "$DISTRO" != "MANJARO" ]; then
		echo "Trying to call installyay while distro is not MANJARO, exiting!"
		exit
	fi

	# Check first if yay is installed
	which yay &>/dev/null
	if [ $? -ne 0 ]; then
		echo "Installing: yay..."
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si
		cd ..
		rm -fr yay
	fi

	echo "Installing: $* ..."
	yay -S --noconfirm $*
}
