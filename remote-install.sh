#!/usr/bin/env bash

# can be ran with:
# curl -o- -L https://raw.githubusercontent.com/Jakob-Koschel/dotfiles/zero/remote-install.sh | bash

set -e

git clone https://github.com/Jakob-Koschel/dotfiles.git
cd dotfiles
git checkout zero
bash setup.sh
