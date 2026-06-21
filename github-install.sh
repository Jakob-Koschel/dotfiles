#!/usr/bin/env bash

# can be ran with:
# bash <(curl -L -s https://raw.githubusercontent.com/Jakob-Koschel/dotfiles/main/github-install.sh)

set -e

git clone --recurse-submodules https://github.com/Jakob-Koschel/dotfiles.git
cd dotfiles

# offer to replace the HTTPS clone URL with SSH for future pulls
GIT_REMOTE_URL=$(git remote get-url origin)
if [[ $GIT_REMOTE_URL == https* ]]; then
  read -p "Repository is cloned via HTTPS. Should this be replaced with SSH? [yN]: " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    REPO=$(echo $GIT_REMOTE_URL | sed -n 's@^.*github.com/*/\([^)]*\).*$@\1@p')
    USERNAME=${REPO%/*}
    REPOSITORY=${REPO#*/}
    git remote set-url origin "git@github.com:$USERNAME/$REPOSITORY"
  fi
fi

./setup.sh
