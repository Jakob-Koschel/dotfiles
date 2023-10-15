#!/usr/bin/env bash

set -e

# virtualenv stuff is essential
if ! pip3 show virtualenv >/dev/null; then
  pip3 install --user virtualenv
fi
if ! pip3 show virtualenvwrapper >/dev/null; then
  pip3 install --user virtualenvwrapper
fi


# pynvim for neovim support
if ! pip3 show pynvim >/dev/null; then
  pip3 install --user pynvim
fi
