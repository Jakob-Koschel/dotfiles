#!/usr/bin/env bash

set -e

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Enable highlight hover effect for the grid view of a stack (Dock)
# defaults write com.apple.dock mouse-over-hilite-stack -bool true

# disable showing recent open apps
defaults write com.apple.dock show-recents -bool FALSE

# Set the icon size of Dock items to 41 pixels
defaults write com.apple.dock tilesize -int 41

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "genie"

# Minimize windows into their application’s icon
#defaults write com.apple.dock minimize-to-application -bool true

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array

# Don’t animate opening applications from the Dock
# defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Modify dock items
if dockutil --find "Launchpad"; then
  dockutil --remove "Launchpad"
fi
if dockutil --find "Safari"; then
  dockutil --remove "Safari"
fi
if dockutil --find "Maps"; then
  dockutil --remove "Maps"
fi
if dockutil --find "Photos"; then
  dockutil --remove "Photos"
fi
if dockutil --find "Reminders"; then
  dockutil --remove "Reminders"
fi
if dockutil --find "Contacts"; then
  dockutil --remove "Contacts"
fi
if dockutil --find "Music"; then
  dockutil --remove "Music"
fi
if dockutil --find "Podcasts"; then
  dockutil --remove "Podcasts"
fi
if dockutil --find "News"; then
  dockutil --remove "News"
fi
if dockutil --find "TV"; then
  dockutil --remove "TV"
fi
if dockutil --find "App Store"; then
  dockutil --remove "App Store"
fi
if dockutil --find "Keynote"; then
  dockutil --remove "Keynote"
fi
if dockutil --find "Numbers"; then
  dockutil --remove "Numbers"
fi
if dockutil --find "Pages"; then
  dockutil --remove "Pages"
fi

if dockutil --find "Mail"; then
  dockutil --move "Mail" --position 'first'
fi
if dockutil --find "Calendar"; then
  dockutil --move "Calendar" --after 'Mail'
fi

if dockutil --find "Google Chrome"; then
  dockutil --move "Google Chrome" --after 'Calendar'
else
  dockutil --add "/Applications/Google Chrome.app" --after 'Calendar'
fi
if dockutil --find "Brave Browser"; then
  dockutil --move "Brave Browser" --after 'Google Chrome'
else
  dockutil --add "/Applications/Brave Browser.app" --after 'Google Chrome'
fi
if dockutil --find "FaceTime"; then
  dockutil --move "FaceTime" --after 'Messages'
else
  dockutil --add "/System/Applications/FaceTime.app" --after 'Messages'
fi
if dockutil --find "Obsidian"; then
  dockutil --move "Obsidian" --after 'FaceTime'
else
  dockutil --add "/System/Applications/Obsidian.app" --after 'FaceTime'
fi
if dockutil --find "Spotify"; then
  dockutil --move "Spotify" --after 'Notes'
else
  dockutil --add /Applications/Spotify.app --after 'Notes'
fi
if dockutil --find "Discord"; then
  dockutil --move "Discord" --after 'Spotify'
else
  dockutil --add /Applications/Discord.app --after 'Spotify'
fi
if dockutil --find "Slack"; then
  dockutil --move "Slack" --after 'Discord'
else
  dockutil --add /Applications/Slack.app --after 'Discord'
fi
if dockutil --find "iTerm"; then
  dockutil --move "iTerm" --after 'Slack'
else
  dockutil --add /Applications/iTerm.app --after 'Slack'
fi

if dockutil --find "Applications"; then
  dockutil --move "Applications" --before 'Downloads'
else
  dockutil --add '/Applications' --view grid --display folder --before 'Downloads'
fi

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
#defaults write com.apple.dock showhidden -bool true

# Disable the Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Reset Launchpad, but keep the desktop wallpaper intact
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete
