#!/bin/sh
set -euo pipefail
set -x



# Script Initialisation
# =====================

# Make sure we can sudo in the middle of the script without needing a password
# by doing a sudo verify right now (might prompt for password),
# and then doing a sudo verify every minute as long as this process is live.
sudo -v
while true
do
    sleep 60
    kill -0 "$$" || exit
    sudo -v
done 2>/dev/null &



# Bootstrap (tools used throughout this script)
# =========

# We assume that tools set up in bootstrap.sh are already in place



# MacOS Settings
# ==============

# Disabled for now: not sure if this is a good way to set these things; it may be better to go through the UI
# echo "Applying Mac OS settings"
# "$(dirname "$0")/apply-settings.sh"



# General UI
# ==========

# Karabiner-Elements (to turn the caps lock key into something useful)
brew install --cask karabiner-elements
sleep 3
open -a Karabiner-Elements

# Hammerspoon (for all manner of shortcuts, including window management, and things using the re-mapped caps lock key)
brew install --cask hammerspoon
sleep 3
open -a hammerspoon

# Disabled for now: I'd like to try things without useing Flux for a while and see how it goes.
# Flux
# brew install --cask flux
# sleep 3
# open -a Flux

# Disabled for now: I'd like to try things without useing Caffeine for a while and see how it goes.
#                   Also, it might make sense to use hammerspoon if I do decide to go for this behaviour again.
# Caffeine
# brew install --cask caffeine
# sleep 3
# open -a Caffeine



# High Priority
# =============

# Shells
brew install bash
brew install bash-completion
brew install zsh
#? curl -L http://install.ohmyz.sh | sh
grep -q "# Shells installed by Homebrew" /etc/shells || {
    echo
    echo "# Shells installed by Homebrew"
    echo /usr/local/bin/bash
    echo /usr/local/bin/zsh
} | sudo tee -a /etc/shells
sudo chsh -s /usr/local/bin/bash "$USER"

# ITerm2
brew install --cask iterm2
sleep 3
open -a iTerm

# Google Chrome
brew install --cask google-chrome
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false  # Disable the all-too-sensitive backswipe
sleep 3
open -a "Google Chrome"



# Applications With Accounts
# ==========================

brew install --cask slack
sleep 3
open -a Slack

brew install --cask signal
sleep 3
open -a Signal

brew install --cask dropbox
sleep 3
open -a Dropbox



# Applications
# ============

brew install vlc



# Shell Utilities
# ===============

brew install curl
brew install jq
brew install parallel
brew install tree
brew install wget



# Software Development
# ====================

brew install cloc
brew install --cask docker
brew install go
brew install graphviz
brew install node

# brew install java
brew install sbt
# brew install scala

brew install --cask intellij-idea-ce
brew install --cask visual-studio-code
