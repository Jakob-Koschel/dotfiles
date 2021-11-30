#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd -P)

if [ "$(uname)" == "Darwin" ]; then
	OS_NAME="macos"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	OS_NAME="linux"
fi

git submodule init && git submodule update

echo "Run $DOTFILES_ROOT/bashdot/bashdot install default $OS_NAME..."
PROFILES="default $OS_NAME"

if [ -s $DOTFILES_ROOT/git-crypt-status ]; then
  read -p "Dotfiles are still encrypted, do you want to decrypt? [yN]: " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git-crypt unlock
    PROFILES="$PROFILES $OS_NAME-crypt"
  fi
else
  PROFILES="$PROFILES $OS_NAME-crypt"
fi

$DOTFILES_ROOT/bashdot install $PROFILES
