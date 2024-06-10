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

1. Run `place_dots.sh` in `dotfiles` folder.
2. Run below two commands, the values depend on your setup:

```bash
export DISTRO=<supported_distro> # MANJARO or UBUNTU
export PROGRAMS_PATH=<programs_directory> # Path of your choice, only temporally used.
```

3. Run all numbered scripts in `installation_scripts` folder in ascending order
   starting with `0_base_system_packages`. You will be prompted for sudo
   password.
