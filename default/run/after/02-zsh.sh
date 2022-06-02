#!/usr/bin/env bash

set -e

if [ ! -e $HOME/.zplug ]; then
  echo "Installing zplug..."
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
else
  zsh -ic "ZPLUG_PIPE_FIX=true zplug update"
fi
