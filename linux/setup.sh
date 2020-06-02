#!/usr/bin/env bash

sudo apt install -y vim tmux build-essential zsh python3-pip

echo "Set zsh as default shell for $USER"
chsh -s /bin/zsh $USER
