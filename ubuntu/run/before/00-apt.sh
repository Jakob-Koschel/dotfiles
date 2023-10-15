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
  git-delta \
  curl \
  tmux \
  python3 \
  python3-dev \
  python3-pip \
  clang \
  clangd \
  llvm \
  cmake \
  time \
  build-essential \
  mosh \
  sudo

if [[ $SHELL == '/bin/bash' ]]; then
  chsh -s $(which zsh)
fi
