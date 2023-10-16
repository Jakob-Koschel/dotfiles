#!/usr/bin/env bash

set -e

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
KEYD_CONF_PATH="$SCRIPTPATH/../../keyd-default.conf"

if ! cmp -s $KEYD_CONF_PATH /etc/keyd/default.conf; then
  # update keyd default.conf
  sudo cp $KEYD_CONF_PATH /etc/keyd/default.conf
fi

if ! command -v keyd &> /dev/null; then
  # install keyd
  mkdir -p ~/Developer
  git clone https://github.com/rvaiya/keyd ~/Developer
  cd ~/Developer/keyd
  make && sudo make install
  sudo systemctl enable keyd && sudo systemctl start keyd
fi

systemctl --user enable keyd-application-mapper.service
systemctl --user start keyd-application-mapper.service
