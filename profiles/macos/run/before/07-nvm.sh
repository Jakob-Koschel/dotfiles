#!/usr/bin/env bash

set -e

export NVM_DIR="$HOME/.nvm"

# Check for nvm, install if necessary
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  echo "Installing nvm..."
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# load nvm
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Install the latest LTS and make 'default' track it for future shells
nvm install --lts
nvm alias default 'lts/*'
