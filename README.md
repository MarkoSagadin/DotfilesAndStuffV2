# DotfilesAndStuffV2

## Content

<!-- vim-markdown-toc GFM -->

* [Intro](#intro)
* [Setup](#setup)

<!-- vim-markdown-toc -->

## Intro

This repository contains two categories of files:
- Various dotfiles with my personal configuration for vim, neovim, tmux, alacritty, zsh and others.
- Several installation scripts that suitable for Ubuntu and Manjaro Linux distributions. Scripts are meant to make development machine bring up process easier. Scripts are separated in several different files, offering a programmer several different layers of installed packages. What you don't need you don't install.

This repository uses Git's bare repository approach.
You can read more about it [here](https://www.atlassian.com/git/tutorials/dotfiles) and [here](https://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/).

This repository is meant to be cloned into home directory (`/home/$USER`).
Read Setup section to understand how to properly setup this repository.


## Setup

To setup on a new machine, run from `$HOME`:

```bash
alias gitc='/usr/bin/git --git-dir=$HOME/.DotfilesAndStuffV2/ --work-tree=$HOME'
git clone --bare https://github.com/MarkoSagadin/DotfilesAndStuffV2.git $HOME/.DotfilesAndStuffV2
```

To checkout `main` branch run:
```bash
gitc checkout
```
Above step will possibly fail because your $HOME folder might already have some stock configuration files which would be overwritten by Git.
The solution is simple: back up the files if you care about them, remove them if you don't care.

Bare repository approach requires extra arguments when doing any git related operations.
To save typing we add an alias, `gitc`.
This alias should be used whenever we git operation related to DotfilesAndStuffV2 repository.
This alias is also in `.zshrc` file.
