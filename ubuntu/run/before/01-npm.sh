#!/usr/bin/env bash

set -e

NVM_DIR=$HOME/.nvm
if [ -n $NVM_DIR ]; then
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  npm -g install diff-so-fancy
fi
