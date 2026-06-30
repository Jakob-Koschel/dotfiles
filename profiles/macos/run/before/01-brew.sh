#!/usr/bin/env bash

set -euo pipefail

# Check for Homebrew, install if necessary
if ! command -v brew >/dev/null; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # A freshly installed Homebrew isn't on PATH yet; load its environment.
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Make sure we're using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install everything declared in the Brewfile.
brew bundle --file="$(dirname "$0")/../../Brewfile"

# Remove outdated versions from the cellar.
brew cleanup

# Upgrade Mac App Store apps
mas upgrade
