# DotfilesAndStuffV2

## Intro

This repository contains two categories of files:

- Various dotfiles with my personal configuration for vim, neovim, tmux,
  alacritty, zsh and others.
- Several installation scripts that are suitable for Ubuntu and Manjaro Linux
  distributions. Scripts are meant to make development machine bring up process
  easier. Scripts are separated in several different files, offering programmer
  several different layers of installed packages. What you don't need you don't
  install.

## New machine setup

Suitable both for Ubuntu Server and Manjaro.

1. Clone repository:

   ```bash
   git clone https://github.com/MarkoSagadin/DotfilesAndStuffV2.git
   ```

2. Run `place_dots.sh` in `dotfiles` folder.
3. Run all numbered scripts in `installation_scripts` folder in ascending order
   starting with `0_base_system_packages.sh`. You will be prompted for sudo
   password.


## Scripts

The following scripts you can find in `installation_scripts` folder:
- `0_base_system_packages.sh` - Installs basic system packages suitable for
  general development on the Linux machine. Optional for Ubuntu: remove Snap
  and install Firefox as `deb` package.

- `1_terminal_setup.sh` - Installs several tools, plugins and fonts, that
  in combination with dotfiles make working in terminal a nice experience.
  After script is done ZSH will be set as a default shell. Terminal emulator
  Alacritty is also installed.  

> [!NOTE]
> Gnome terminal users need to change the font in the Preferences menu to some 
> [Nerd Font] font that supports extra glyphs. Try using the installed 
> `MesloLGSDZ Nerd Font`, your terminal will look nicer.

- `2_install_neovim.sh` - That one is quite clear.

- `3_hyprland_for_ubuntu_24_04.sh` - Installs Hyprland on Ubuntu 24.04.

[Nerd Font]: https://github.com/ryanoasis/nerd-fonts

Improvements:

- Repo should still be able to support simple usecase (no wayland)

TODO:

- swaync is installed and should be some how configured, however nothing
  changes. Reasearch this later.
- add buttons to waybar
  - toggle dark/light theme
- nwg-display can compile but it doesn't run. Check support scripts for
  installation.

Resources:

- https://github.com/zDyanTB/HyprNova
- https://github.com/zDyanTB/aesthetic-wallpapers
- https://github.com/vernette/hyprsnap
- https://github.com/Matt-FTW/dotfiles
- https://github.com/littleblack111/dotfiles
- https://github.com/RUNFUNRUN/dotfiles
- https://github.com/Narmis-E/onedark-wallpapers
- https://github.com/dharmx/walls
- https://github.com/PROxZIMA/.dotfiles
