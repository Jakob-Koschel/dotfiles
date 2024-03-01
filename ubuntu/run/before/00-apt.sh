#!/usr/bin/env bash

set -e

sudo apt-get update
sudo apt-get install -y \
  wget \
  zsh \
  vim \
  neovim \
  fzf \
  git \
  curl \
  tmux \
  python3 \
  python3-dev \
  python3-pip \
  python3-virtualenv \
  python3-virtualenvwrapper \
  python3-pynvim \
  clang \
  clangd \
  llvm \
  cmake \
  time \
  build-essential \
  mosh \
  snapd \
  sudo

sudo snap install git-delta-snap

if [[ $SHELL == '/bin/bash' ]]; then
  chsh -s $(which zsh)
fi
