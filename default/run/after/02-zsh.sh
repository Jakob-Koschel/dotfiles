#!/usr/bin/env bash

set -e

OHMYZSH_GIT_REMOTE="https://github.com/robbyrussell/oh-my-zsh.git"

if [ ! -e $HOME/.oh-my-zsh ]; then
  git clone $OHMYZSH_GIT_REMOTE $HOME/.oh-my-zsh
fi
