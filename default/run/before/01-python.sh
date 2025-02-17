#!/usr/bin/env bash

set -e

source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

# virtualenv stuff is essential
if ! command -v virtualenv &> /dev/null; then
  pip3 install --user virtualenv
fi
if ! command -v virtualenvwrapper &> /dev/null; then
  pip3 install --user virtualenvwrapper
fi

# pynvim for neovim support
if ! pip3 show pynvim >/dev/null; then
  pip3 install --user --break-system-packages pynvim
fi

if ! pip3 show python-dotenv >/dev/null; then
  pip3 install --user --break-system-packages python-dotenv
fi
