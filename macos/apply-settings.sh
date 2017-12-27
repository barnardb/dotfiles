#!/bin/sh
set -euo pipefail
set -x


# Languages & Locale
# ------------------

defaults write -globalDomain AppleLanguages -array en-DE en-CA en-GB de fr ja zh-Hans
defaults write -globalDomain AppleLocale -string en_DE
#defaults write /Library/Preferences/.GlobalPreferences Country "en_DE"
#defaults write -globalDomain AppleMeasurementUnits -string "Centimeters"
#defaults write -globalDomain AppleMetricUnits -bool true
#defaults write -globalDomain AppleICUDateFormatStrings -dict-add "1" "y-MM-dd"


# Trackpad
# --------

# Enable tap-to-click
defaults write -globalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Speed up pointer
defaults write -globalDomain com.apple.trackpad.scaling -float 4.0


# Keyboard
# --------

# Set a very short keyboard repeat delay
defaults write -globalDomain InitialKeyRepeat -int 10

# Set a very fast keyboard repeat rate
defaults write -globalDomain KeyRepeat -int 1

# Make the F-keys work without holding <fn>, instead of as media control keys
defaults write -globalDomain com.apple.keyboard.fnState -bool true

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write -globalDomain AppleKeyboardUIMode -int 3


# Menu Bar
# --------

defaults write com.apple.menuextra.battery ShowPercent -bool true
defaults write com.apple.menuextra.clock DateFormat -string 'EEEEE d MMM  HH:mm'
#defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
#defaults write com.apple.menuextra.clock IsAnalog -bool false

# Apply settings
killall -SIGHUP SystemUIServer


# Dock
# ----

# Smaller size
defaults write com.apple.dock tilesize -int 48

# Instant auto(un)hiding
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array

# Speed up exposé (at least when accessed with the keyboard)
defaults write com.apple.dock expose-animation-duration -float 0.05

# Apply settings
killall -SIGHUP Dock


# Other OS Settings
# -----------------

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Set home directory as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Expand save panel by default
defaults write -globalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write -globalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write -globalDomain PMPrintingExpandedStateForPrint -bool true
defaults write -globalDomain PMPrintingExpandedStateForPrint2 -bool true

# Don't convert "--" to m/n-dash
defaults write -globalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Speed up window resizing
defaults write -globalDomain NSWindowResizeTime -float 0.001
