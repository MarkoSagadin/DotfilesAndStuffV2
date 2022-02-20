#!/usr/bin/env bash

dotfilesDir=$(pwd)

function linkDotfile {
	dest="${1}/${2}"
	dateStr=$(date +%Y-%m-%d-%H%M)

	if [ -h ~/${2} ]; then
		# Existing symlink
		echo "Removing existing symlink: ${dest}"
		rm ${dest}

	elif [ -f "${dest}" ]; then
		# Existing file
		echo "Backing up existing file: ${dest}"
		mv ${dest}{,.${dateStr}}

	elif [ -d "${dest}" ]; then
		# Existing dir
		echo "Backing up existing dir: ${dest}"
		mv ${dest}{,.${dateStr}}
	fi

	echo "Creating new symlink: ${dest}"
	ln -s ${dotfilesDir}/${2} ${dest}
}

# Create symlink for a file/folder on a right in the folder on the left
linkDotfile /home/$USER .config
linkDotfile /home/$USER .ssh
linkDotfile /home/$USER .zsh
linkDotfile /home/$USER .gitconfig
linkDotfile /home/$USER .tmux.conf
linkDotfile /home/$USER .vimrc
linkDotfile /home/$USER .zshrc
