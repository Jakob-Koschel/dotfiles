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

###############################################################################
# Dock contents (dockutil)                                                    #
#                                                                             #
# All dockutil calls use --no-restart; the Dock is restarted once at the end. #
###############################################################################

# Move an existing Dock item; no-op if it isn't present.
move_item() {  # label, position-args...
  local label=$1; shift
  if dockutil --find "$label" >/dev/null 2>&1; then
    dockutil --move "$label" "$@" --no-restart
  fi
}

# Ensure an app is in the Dock: move it if present, add it if installed,
# otherwise skip (so a missing app doesn't abort the run).
place_app() {  # label, app-path, position-args...
  local label=$1 path=$2; shift 2
  if dockutil --find "$label" >/dev/null 2>&1; then
    dockutil --move "$label" "$@" --no-restart
  elif [[ -e "$path" ]]; then
    dockutil --add "$path" "$@" --no-restart
  else
    echo "skipping Dock entry '$label': $path not found"
  fi
}

# Remove unwanted default Dock items
remove_items=(
  Launchpad Safari Maps Photos Reminders Contacts Music
  Podcasts News TV "App Store" Keynote Numbers Pages
)
for item in "${remove_items[@]}"; do
  if dockutil --find "$item" >/dev/null 2>&1; then
    dockutil --remove "$item" --no-restart
  fi
done

# Order the Dock
move_item "Mail"     --position first
move_item "Calendar" --after Mail
place_app "Firefox"                   "/Applications/Firefox.app"                   --after Calendar
place_app "Firefox Developer Edition" "/Applications/Firefox Developer Edition.app" --after Firefox
place_app "FaceTime"                  "/System/Applications/FaceTime.app"           --after Messages
place_app "Obsidian"                  "/Applications/Obsidian.app"                  --after FaceTime
place_app "Spotify"                   "/Applications/Spotify.app"                   --after Notes
place_app "Discord"                   "/Applications/Discord.app"                   --after Spotify
place_app "Slack"                     "/Applications/Slack.app"                     --after Discord
place_app "iTerm"                     "/Applications/iTerm.app"                     --after Slack

# Applications stack (added as a grid folder view if not already present)
if dockutil --find "Applications" >/dev/null 2>&1; then
  dockutil --move "Applications" --before Downloads --no-restart
else
  dockutil --add "/Applications" --view grid --display folder --before Downloads --no-restart
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
find "${HOME}/Library/Application Support/Dock" -maxdepth 1 -name "*-*.db" -delete

# Apply all of the above with a single Dock restart
killall Dock
