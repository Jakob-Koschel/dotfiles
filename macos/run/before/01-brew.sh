#!/usr/bin/env bash

set -e

# Check for Homebrew,
# Install if necessary
if ! command -v brew >/dev/null; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install
(cd "$(dirname "$0")/../.." && brew bundle)

# Upgrade Mac App Store apps
mas upgrade

# Remove outdated versions from the cellar.
brew cleanup
