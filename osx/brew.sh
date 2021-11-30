#!/usr/bin/env bash

# source: https://github.com/donnemartin/dev-setup/blob/master/brew.sh

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install other useful binaries.
brew install \
  coreutils \
  moreutils \
  findutils \
  gnu-sed \
  tmux \
  vim \
  grep \
  bash \
  zsh \
  `# node` \
  nvm \
  python \
  python3 \
  flake8 \
  `# some CTF tools ` \
  binutils \
  netpbm \
  socat \
  xz \
  `# other useful binaries ` \
  ack \
  ctags \
  curl \
  dark-mode \
  diff-so-fancy \
  dockutil \
  git \
  git-crypt \
  hexedit \
  htop \
  hub \
  lynx \
  openssl \
  reattach-to-user-namespace \
  rename \
  ssh-copy-id \
  tree \
  webkit2png \
  pkg-config libffi \
  pandoc \
  weechat \
  wget \
  z \
  dialog \
  svn # required for font-roboto-mono-for-powerline

# # We installed the new shell, now we have to activate it
# echo "Adding the newly installed shell to the list of allowed shells"
# # Prompts for password
# sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'

# Lxml and Libxslt
brew install libxml2
brew install libxslt
brew link libxml2 --force
brew link libxslt --force

# Core casks
brew install --cask --appdir="/Applications" alfred
brew install --cask --appdir="~/Applications" iterm2
brew install --cask --appdir="~/Applications" xquartz

# Development tool casks
brew install --cask --appdir="/Applications" macdown

# Misc casks
brew install --cask --appdir="/Applications" little-snitch
brew install --cask --appdir="/Applications" google-chrome
brew install --cask --appdir="/Applications" brave-browser
brew install --cask --appdir="/Applications" karabiner-elements
brew install --cask --appdir="/Applications" sdformatter
brew install --cask --appdir="/Applications" spotify
brew install --cask --appdir="/Applications" the-unarchiver
brew install --cask --appdir="/Applications" caffeine
brew install --cask --appdir="/Applications" spectacle
brew install --cask --appdir="/Applications" vlc
brew install --cask --appdir="/Applications" slack

# VeraCrypt
# Hidden Bar
# Atom (for Tabletop Simulator)
# Docker
# Jaxx Liberty
# JDownloader2
# Signal
# Steam
# SURFdrive
# TeamViewer
# Telegram
# Wireguard
# Zotero
# Zoom
# VirtualBox

# Remove comment to install LaTeX distribution MacTeX
brew install --cask --appdir="/Applications" mactex

brew install --cask font-roboto-mono-for-powerline

# # start necessary apps
# open "/Applications/Alfred 4.app"
# open "/Applications/Caffeine.app"
# open "/Applications/Spectacle.app"

# install virtualenvwrapper
pip3 install virtualenvwrapper

# Remove outdated versions from the cellar.
brew cleanup
