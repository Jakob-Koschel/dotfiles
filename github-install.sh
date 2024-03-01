#!/usr/bin/env bash

# can be ran with:
# bash <(curl -L -s https://raw.githubusercontent.com/Jakob-Koschel/dotfiles/main/github-install.sh)

set -e

git clone https://github.com/Jakob-Koschel/dotfiles.git
cd dotfiles
./setup.sh
