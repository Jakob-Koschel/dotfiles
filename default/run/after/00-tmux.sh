#!/usr/bin/env bash

set -e

TPM_GIT_REMOTE="https://github.com/tmux-plugins/tpm.git"

if [ ! -e $HOME/.tmux/plugins/tpm ]; then
  git clone $TPM_GIT_REMOTE $HOME/.tmux/plugins/tpm
fi

tmux source $HOME/.tmux.conf && $HOME/.tmux/plugins/tpm/scripts/install_plugins.sh
