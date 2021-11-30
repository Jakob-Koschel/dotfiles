#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd -P)

if [ "$(uname)" == "Darwin" ]; then
	OS_NAME="macos"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	OS_NAME="linux"
fi

git submodule init && git submodule update

echo "Run $DOTFILES_ROOT/bashdot/bashdot install default $OS_NAME..."
$DOTFILES_ROOT/bashdot/bashdot install default $OS_NAME
