#!/usr/bin/env bash

set -e

sudo apt-get update
sudo apt-get install -y \
  wget \
  zsh \
  vim \
  git \
  curl \
  tmux \
  python3 \
  python3-dev \
  clang \
  llvm \
  cmake \
  time \
  build-essential \
  sudo
