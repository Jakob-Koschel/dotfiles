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
  `# node` \
  nvm \
  `# python` \
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
  z

# We installed the new shell, now we have to activate it
echo "Adding the newly installed shell to the list of allowed shells"
# Prompts for password
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'

# Lxml and Libxslt
brew install libxml2
brew install libxslt
brew link libxml2 --force
brew link libxslt --force

# Core casks
brew cask list alfred  || brew cask install --appdir="/Applications" alfred
brew cask list iterm2  || brew cask install --appdir="~/Applications" iterm2
brew cask list xquartz || brew cask install --appdir="~/Applications" xquartz

# Development tool casks
brew cask list macdown || brew cask install --appdir="/Applications" macdown

# Misc casks
brew cask list little-snitch      || brew cask install --appdir="/Applications" little-snitch
brew cask list google-backup-and-sync || brew cask install --appdir="/Applications" google-backup-and-sync
brew cask list google-chrome      || brew cask install --appdir="/Applications" google-chrome
brew cask list brave-browser      || brew cask install --appdir="/Applications" brave-browser
brew cask list karabiner-elements || brew cask install --appdir="/Applications" karabiner-elements
brew cask list sdformatter        || brew cask install --appdir="/Applications" sdformatter
brew cask list spotify            || brew cask install --appdir="/Applications" spotify
brew cask list the-unarchiver     || brew cask install --appdir="/Applications" the-unarchiver
brew cask list caffeine           || brew cask install --appdir="/Applications" caffeine
brew cask list spectacle          || brew cask install --appdir="/Applications" spectacle
brew cask list thunderbird        || brew cask install --appdir="/Applications" thunderbird
brew cask list vlc                || brew cask install --appdir="/Applications" vlc
brew cask list visual-studio-code || brew cask install --appdir="/Applications" visual-studio-code
brew cask list slack              || brew cask install --appdir="/Applications" slack

#Remove comment to install LaTeX distribution MacTeX
brew cask list mactex || brew cask install --appdir="/Applications" mactex

# Install developer friendly quick look plugins;
# see https://github.com/sindresorhus/quick-look-plugins
brew cask install \
  qlcolorcode \
  qlstephen \
  qlmarkdown \
  quicklook-json \
  qlprettypatch \
  quicklook-csv \
  qlimagesize

# Remove outdated versions from the cellar.
brew cleanup
