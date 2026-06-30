#!/usr/bin/env bash

set -e

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
# defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show icons for hard drives, servers, and removable media on the desktop
# defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
# defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
# defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
# defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Tweak the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float .5

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show item info near icons on the desktop and in other icon views
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Configure desktop/Finder icon view settings, adding keys that don't exist yet
# (a bare Set would abort under `set -e` when the sub-dict isn't present).
finder_plist="$HOME/Library/Preferences/com.apple.finder.plist"
set_finder_view() {  # key-path, type, value
  local key=$1 type=$2 value=$3
  if /usr/libexec/PlistBuddy -c "Print $key" "$finder_plist" >/dev/null 2>&1; then
    /usr/libexec/PlistBuddy -c "Set $key $value" "$finder_plist"
  else
    /usr/libexec/PlistBuddy -c "Add $key $type $value" "$finder_plist"
  fi
}

# Show item info at the bottom of the icons on the desktop
set_finder_view ":DesktopViewSettings:IconViewSettings:labelOnBottom" bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
set_finder_view ":DesktopViewSettings:IconViewSettings:arrangeBy"     string grid
set_finder_view ":FK_StandardViewSettings:IconViewSettings:arrangeBy" string grid
set_finder_view ":StandardViewSettings:IconViewSettings:arrangeBy"    string grid

# Set grid spacing for icons on the desktop and in other icon views
set_finder_view ":DesktopViewSettings:IconViewSettings:gridSpacing"     integer 50
set_finder_view ":FK_StandardViewSettings:IconViewSettings:gridSpacing" integer 50
set_finder_view ":StandardViewSettings:IconViewSettings:gridSpacing"    integer 50

# Set the size of icons on the desktop and in other icon views
set_finder_view ":DesktopViewSettings:IconViewSettings:iconSize"     integer 48
set_finder_view ":FK_StandardViewSettings:IconViewSettings:iconSize" integer 48
set_finder_view ":StandardViewSettings:IconViewSettings:iconSize"    integer 48

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
# defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
# defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show the ~/Library folder
sudo chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# Configure the Finder sidebar (remove the defaults, add ~/Developer and ~).
# The helper talks to LSSharedFileList directly, so it only needs pyobjc; run it
# from a throwaway virtualenv that is cleaned up on exit.
mkdir -p "$HOME/Developer"

sidebar_venv="$(mktemp -d)"
trap 'rm -rf "$sidebar_venv"' EXIT
python3 -m venv "$sidebar_venv"
"$sidebar_venv/bin/pip" install --quiet --upgrade pip
"$sidebar_venv/bin/pip" install --quiet pyobjc
"$sidebar_venv/bin/python" "$(dirname "$0")/../../finder-sidebar-editor.py"
