#!/usr/bin/env bash

set -e

if command -v npm &> /dev/null
then
  npm -g install diff-so-fancy
fi
