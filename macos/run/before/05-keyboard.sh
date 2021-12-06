#!/usr/bin/env bash

set -e

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
# defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "en-US" "de-DE"
defaults write NSGlobalDomain AppleLocale -string "en_DE"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# TODO: add other keyboards

# Disable shortcut to change input source (in favor of opening iTerm hotkey window)
/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist -c \
  "Set AppleSymbolicHotKeys:60:enabled false"
/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist -c \
  "Set AppleSymbolicHotKeys:61:enabled false"

# change spotlight shortcut
if /usr/libexec/PlistBuddy -c "Print AppleSymbolicHotKeys:64:value:parameters:2" ~/Library/Preferences/com.apple.symbolichotkeys.plist; then
  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist -c "Set AppleSymbolicHotKeys:64:value:parameters:2 524288"
else
  /usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist -c "Add AppleSymbolicHotKeys:64:value:parameters:2 integer 524288"
fi
