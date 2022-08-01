#!/usr/bin/env bash

set -e

sudo pacman -Syy
sudo pacman -S --noconfirm \
  bat \
  diff-so-fancy \
  zsh \
  vim \
  neovim \
  git \
  tmux \
  python \
  python-pip

# sudo apt-get update
# sudo apt-get install -y \
#   wget \
#   zsh \
#   vim \
#   neovim \
#   fzf \
#   git \
#   curl \
#   tmux \
#   python3 \
#   python3-dev \
#   clang \
#   clangd \
#   llvm \
#   cmake \
#   time \
#   build-essential \
#   sudo

if [[ $SHELL == '/bin/bash' ]]; then
  chsh -s $(which zsh)
fi
