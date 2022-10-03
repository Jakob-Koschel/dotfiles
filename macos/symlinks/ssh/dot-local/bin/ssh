#!/bin/bash

# Inspired by: https://engineering.talis.com/articles/bash-osx-colored-ssh-terminal/

iterm2_set_user_var () {
  printf "\033]1337;SetUserVar=%s=%s\007" "$1" $(printf "%s" "$2" | base64 | tr -d '\n')
}

change_profile () {
  NAME=$1; if [ -z "$NAME" ]; then NAME="$SSH_DEFAULT_THEME"; fi
  echo -e "\033]50;SetProfile=$NAME\a"
  iterm2_set_user_var current_ssh_host "$HOSTNAME"
}

on_exit () {
  change_profile
  iterm2_set_user_var current_ssh_host ""
}
trap on_exit EXIT

# HOSTNAME=`echo $@ | sed s/.*@//`

change_profile "Remote"

# echo "Connecting to $HOSTNAME"

/usr/bin/ssh "$@"
