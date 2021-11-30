#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd -P)

if [ "$(uname)" == "Darwin" ]; then
	OS_NAME="macos"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	OS_NAME="linux"
fi

# check if remote is using HTTPS, if so offer replacment with SSH
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

git submodule init && git submodule update

echo "Run $DOTFILES_ROOT/bashdot/bashdot install default $OS_NAME..."
PROFILES="default $OS_NAME"

# check if repo is still locked and should be unlocked
if [ -s $DOTFILES_ROOT/git-crypt-status ]; then
  read -p "Dotfiles are still encrypted, do you want to decrypt? [yN]: " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ ! -e dotfiles-key ]; then
      echo "store the gpg key in as dotfiles-key"
      exit 1
    fi
    git-crypt unlock dotfiles-key
    PROFILES="$PROFILES $OS_NAME-crypt"
  fi
else
  PROFILES="$PROFILES $OS_NAME-crypt"
fi

$DOTFILES_ROOT/bashdot install $PROFILES
