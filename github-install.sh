#!/usr/bin/env bash

# can be ran with:
# bash <(curl -L -s https://raw.githubusercontent.com/Jakob-Koschel/dotfiles/main/github-install.sh)

set -euo pipefail

if [ ! -d dotfiles ]; then
  git clone --recurse-submodules https://github.com/Jakob-Koschel/dotfiles.git
fi
cd dotfiles

# offer to replace the HTTPS clone URL with SSH for future pulls
remote_url=$(git remote get-url origin)
if [[ $remote_url == https://github.com/* ]]; then
  read -rp "Repository is cloned via HTTPS. Should this be replaced with SSH? [yN]: " -n 1; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # strip the prefix -> "OWNER/REPO.git", which is exactly the SSH path
    git remote set-url origin "git@github.com:${remote_url#https://github.com/}"
  fi
fi

./setup.sh
