#!/usr/bin/env bash

# can be ran with:
# curl -o- -L https://raw.githubusercontent.com/Jakob-Koschel/dotfiles/zero/remote-install.sh | bash

git clone https://github.com/Jakob-Koschel/dotfiles.git

echo "TESTING"
cd dotfiles
git checkout zero
# ./setup.sh
