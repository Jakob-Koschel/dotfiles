#!/usr/bin/env bash

set -e

# Menu bar items are managed by Control Center since macOS 11 (Big Sur); the old
# SystemUIServer "Menu Extras" mechanism no longer exists. Note: Siri and Time
# Machine have no reliable defaults key to hide them -- do that in System
# Settings > Control Center if needed.

# Show items in the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible Battery"   -int 1
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -int 1
defaults write com.apple.controlcenter "NSStatusItem Visible Sound"     -int 1   # volume
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi"      -int 1   # airport
defaults write com.apple.controlcenter "NSStatusItem Visible Clock"     -int 1

# Show the battery percentage
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

# Use a digital (not analog) menu bar clock. The clock's date/time format is
# driven by the Show* keys below rather than the old DateFormat string.
defaults write com.apple.menuextra.clock IsAnalog       -bool false
defaults write com.apple.menuextra.clock Show24Hour     -bool true
defaults write com.apple.menuextra.clock ShowDate       -int 1
defaults write com.apple.menuextra.clock ShowDayOfWeek  -bool true
defaults write com.apple.menuextra.clock ShowAMPM       -bool false

# restart to reflect changes
killall ControlCenter
