#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install
(cd $(PWD)/../../ && brew bundle)

# Remove outdated versions from the cellar.
brew cleanup
