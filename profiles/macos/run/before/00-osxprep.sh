#!/usr/bin/env bash

# source: https://github.com/donnemartin/dev-setup/blob/master/osxprep.sh

set -euo pipefail

# Ask for the administrator password upfront
sudo -v

# Keep `sudo` alive until this script exits, then stop the keep-alive loop.
while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT

# Step 1: Update the OS and Install Xcode Tools
echo "------------------------------"
echo "Updating macOS.  If this requires a restart, run the script again."
# Install all available updates (use -ir instead of -ia to skip major OS upgrades)
sudo softwareupdate -ia --verbose

# Install Rosetta 2 on Apple Silicon if it isn't already present
if [[ "$(uname -m)" == "arm64" ]]; then
  if ! /usr/bin/pgrep -q oahd; then
    sudo softwareupdate --install-rosetta --agree-to-license
  fi
fi

echo "------------------------------"
# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools."
  xcode-select --install || true
  # xcode-select --install launches a GUI installer and returns immediately;
  # wait for the tools to actually finish installing before continuing.
  until xcode-select -p >/dev/null 2>&1; do
    sleep 10
  done
else
  echo "Xcode Command Line Tools already installed."
fi
