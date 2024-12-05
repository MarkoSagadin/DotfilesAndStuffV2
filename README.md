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
   starting with `0_base_system_packages`. You will be prompted for sudo
   password.

Improvements:

- Repo should still be able to support simple usecase (no wayland)

TODO:

- Make sure that the added cursor theme is commited
- add some nice icon theme
- Add some nice thunar theme
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
