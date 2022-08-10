#!/usr/bin/env bash

set -e

sudo pacman -Syy
sudo pacman -Syu --noconfirm \
  `# Build essentials` \
  base-devel \
  gdb \
  cmake \
  clang \
  `# Essential tools` \
  bat \
  diff-so-fancy \
  git \
  htop \
  man \
  neovim \
  python \
  python-pip \
  rsync \
  tmux \
  vim \
  zsh \
  `# Networking` \
  dhcpcd \
  openssh \
  `# Sway` \
  alacritty \
  dmenu \
  foot \
  sway \
  swaybg \
  wayvnc \
  xorg-xlsclients \
  xorg-xwayland \
  `# KVM` \
  dnsmasq \
  bridge-utils \
  openbsd-netcat \
  virt-manager \
  qemu-base \
  `# Misc` \
  usbutils \
  `# Compiling linux` \
  bc \
  `# syzkaller` \
  debootstrap


if [[ $SHELL == '/bin/bash' ]]; then
  chsh -s $(which zsh)
fi
