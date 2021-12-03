#!/usr/bin/env bash

set -e

# Check for Homebrew,
# Install if necessary
if ! command -v brew >/dev/null; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install
(cd $(PWD)/../../ && brew bundle)

# Remove outdated versions from the cellar.
brew cleanup