#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd -P)

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

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
  # many other tests omitted
else
  case $(ps -o comm= -p "$PPID") in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi

if [ "$(uname)" == "Darwin" ]; then
  PROFILES="macos"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  if [ -f "/etc/arch-release" ]; then
    PROFILES="arch linux"

    # check if stow is installed
    if ! command -v stow &> /dev/null
    then
      sudo pacman -S --noconfirm stow
    fi
  fi
  DISTRIBUTION="$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')"
  if [[ "$DISTRIBUTION" == "Ubuntu" ]] || [[ "$DISTRIBUTION" == "Debian GNU/Linux"* ]]; then
    PROFILES="ubuntu linux"
    if [[ "$SESSION_TYPE" != "remote/ssh" ]]; then
      PROFILES="$PROFILES ubuntu-desktop"
    fi

    # check if stow is installed
    if ! command -v stow &> /dev/null
    then
      sudo apt update && sudo apt install -y stow
    fi
  fi
  if [[ "$SESSION_TYPE" != "remote/ssh" ]]; then
    PROFILES="$PROFILES linux-desktop"
  fi
fi

PROFILES="$PROFILES default"

echo "Run $DOTFILES_ROOT/bashdot/bashdot/bashdot install $PROFILES..."

# make sure that /usr/local/bin is in PATH
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

$DOTFILES_ROOT/bashdot/bashdot before  $PROFILES
$DOTFILES_ROOT/bashdot/bashdot install $PROFILES
$DOTFILES_ROOT/bashdot/bashdot after   $PROFILES
