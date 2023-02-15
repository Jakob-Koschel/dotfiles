#!/usr/bin/env bash

set -e

if command -v znap >/dev/null; then
  znap pull
fi
