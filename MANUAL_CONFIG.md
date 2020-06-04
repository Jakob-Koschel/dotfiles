# Config

## Brave

### Plugins

- uBlock Origin
- LastPass
- HTTPS Everywhere

### Settings

- disabled sponsored images
- import bookmarks backup
- set google as default search engine
- make it default browser
- offer to save passwords should be set to no
- auto sign-in off


## Alfred
- remap spotlight to control + space
- remap to command + space

## Spectacle
- open at launch

## Karabiner
- `Security & Privacy` -> `Privacy` -> `Input Monitoring`:
	- Enable `karabiner_grabber` & `karabiner_observer`

## Little Snitch
- `open /usr/local/Caskroom/little-snitch/4.5.2/LittleSnitch-4.5.2.dmg` (adapt to necessary version to run the installer)
- `Preferences` -> `Monitor`: `Show data rates as numerical values`

## Notes
- `Preferences` -> `New notes starts with` = `Body`

## Check Autostart Applications
- `Users & Groups` -> `Login Items`


# Maybe

## Accessiblity
- Eventually go to `Display` -> `Reduce transparency` (`osx.sh` required full disk access to do this)

## iTerm
`Preferences` -> `Profiles` -> `Hotkey Window` -> `Keys` -> `Retoggle 'A hotkey opens a dedicated window with this profile'` then allow iTerm under `Security & Privacy` -> `Privacy` -> `Accessiblity`

## Keyboard
open keyboard settings -> `Modifier Keys` and verify that `Karabiner` is selected

## PlistBuddy
certain plist types did not exist when running `osx.sh`

Add instead of Set with type, see here: https://github.com/mathiasbynens/dotfiles/issues/786