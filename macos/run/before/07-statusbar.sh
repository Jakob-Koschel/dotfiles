#!/usr/bin/env bash

set -e

# TODO: test if everything is there

defaults write com.apple.systemuiserver "NSStatusItem Visible Siri" -int 0
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.TimeMachine" -int 0

defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -int 1
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.airport" -int 1
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.clock" -int 1
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -int 1
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.battery" -int 1

defaults write com.apple.systemuiserver menuExtras -array \
      "/System/Library/CoreServices/Menu Extras/Volume.menu" \
      "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
      "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
      "/System/Library/CoreServices/Menu Extras/Battery.menu" \
      "/System/Library/CoreServices/Menu Extras/Clock.menu"

# TODO: bluetooth now lives in 'Library/Preferences/com.apple.controlcenter.plist'

# show the percentage of battery
defaults write com.apple.menuextra.battery ShowPercent YES

# include the date in the menu bar clock
defaults write com.apple.menuextra.clock IsAnalog -bool false
defaults write com.apple.menuextra.clock DateFormat -string "EEE d. MMM  HH:mm"

# restart to reflect changes
killall SystemUIServer
