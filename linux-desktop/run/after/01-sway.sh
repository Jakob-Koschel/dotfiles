#!/usr/bin/env bash

set -e

RELEASE="v0.2.3-fix"
URL="https://github.com/korreman/sway-overfocus/releases/download/$RELEASE/sway-overfocus-$RELEASE-x86_64.tar.gz"

if ! command -v ~/.local/bin/sway-overfocus &> /dev/null; then
  # install sway-overfocus
  curl -L $URL > ~/.local/bin/sway-overfocus.tar.gz
  cd ~/.local/bin && tar -xvf ~/.local/bin/sway-overfocus.tar.gz
  rm -f ~/.local/bin/sway-overfocus.tar.gz
fi

