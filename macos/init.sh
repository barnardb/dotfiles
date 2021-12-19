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

# Homebrew Cask
brew tap caskroom/cask
brew cask doctor



# MacOS Settings
# ==============

echo "Applying Mac OS settings"
"$(dirname "$0")/apply-settings.sh"



# General UI
# ==========

# Karabiner-Elements (to turn the caps lock key into something useful)
brew install karabiner-elements
sleep 1
open -a Karabiner-Elements

# Hammerspoon (for all manner of shortcuts, including window management, and things using the re-mapped caps lock key)
brew install hammerspoon
sleep 1
open -a hammerspoon

# Flux
brew cask install flux
sleep 1
open -a Flux

# Spectacle
brew cask install Spectacle
# TODO: restore spectacle settings
sleep 1
open -a Spectacle

# Caffeine
brew cask install caffeine
sleep 1
open -a Caffeine



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
brew cask install iterm2
sleep 1
open -a iTerm

# Google Chrome
brew cask install google-chrome
# Disable the all-too-sensitive backswipe
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
#defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
sleep 1
open -a "Google Chrome"



# Cloud Storage
# =============

# brew cask install dropbox
# sleep 1
# open -a Dropbox



# Applications
# ============

brew cask install firefox
brew cask install skype
brew cask install slack
brew cask install vlc
brew cask install whatsapp



# Shell Utilities
# ===============

brew install httpie
brew install parallel
brew install tree
brew install wget



# Software Development
# ====================

brew install cloc
brew install docker
brew install golang
brew install graphviz
brew install node.js
brew install rust

brew cask install java
brew install sbt
brew install scala

brew cask install intellij-idea-ce
brew cask install virtualbox
brew cask install vagrant
