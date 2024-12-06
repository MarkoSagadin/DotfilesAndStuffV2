#!/usr/bin/env bash

SUPPORTED_DISTROS=("Ubuntu" "Manjaro Linux")

# Usage: check_distro
# Variable DISTRO should be exported before calling this function.
# Variable DISTRO should be either set to MANJARO or UBUNTU
# This function should be called first before calling any other function from this file
function check_distro {
    # Get the distribution name from /etc/os-release
    distro_name=$(grep -w "NAME" /etc/os-release | cut -d= -f2 | tr -d '"')

	if [[ ! " ${SUPPORTED_DISTROS[*]} " =~ " ${distro_name} " ]]; then
		echo "Given distro $distro_name is not supported!"
		echo "Supported distros are:"
		for SUPPORTED_DISTRO in ${SUPPORTED_DISTROS[@]}; do
			echo " - $SUPPORTED_DISTRO"
		done
		exit
	fi

    # If the distribution is supported, store the name
	if [ "$distro_name" = "Manjaro Linux" ]; then
        export DISTRO="MANJARO"
	elif [ "$distro_name" = "Ubuntu" ]; then
        export DISTRO="UBUNTU"
	else
        echo "Unsupported distribution: $distro_name"
		exit 1
	fi
}

# Function to ask a yes/no question and set the response in a variable
# Usage: ask_yes_no <yes/no question> <variable to save anwser into>
ask_yes_no() {
    while true; do
        read -p "$1 (y/n): " choice
        case "$choice" in
            [Yy]* ) eval "$2='Y'"; break;;
            [Nn]* ) eval "$2='N'"; break;;
            * ) echo "Please answer with y or n.";;
        esac
    done
}



# Usage: update
# It expects that the variable 'DISTRO' is set
function update {
	echo "Updating: $* ..."
	if [ "$DISTRO" = "MANJARO" ]; then
		sudo pacman -Syu --noconfirm
	elif [ "$DISTRO" = "UBUNTU" ]; then
		sudo apt update -y
		sudo apt upgrade -y
	else
		echo "Ops, something went wrong, time to debug!"
		exit
	fi
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

# Usage: remove <package_name> <more_packages>
# It expects that the variable 'DISTRO' is set
function remove {
	echo "Removing: $* ..."
	if [ "$DISTRO" = "MANJARO" ]; then
		sudo pacman -R --noconfirm $*
	elif [ "$DISTRO" = "UBUNTU" ]; then
		sudo apt purge $* -y
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
