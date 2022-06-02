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
  clang \
  clangd \
  llvm \
  cmake \
  time \
  build-essential \
  sudo

# https://github.com/BurntSushi/ripgrep/issues/1777#issuecomment-866964695
sudo apt install -o Dpkg::Options::="--force-overwrite" bat ripgrep

ln -sfn /usr/bin/batcat ~/.local/bin/bat
