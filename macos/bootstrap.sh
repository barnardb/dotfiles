#!/bin/sh
set -euo pipefail
set -x

# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor

# Up-to-date git
brew install git
hash -r  # make the current shell forget old executable locations, so it finds new git

# Clone dotfiles repo
cd ~
mkdir -p personal
-d dotfiles/.git || git clone git@github.com:barnardb/dotfiles.git

# Run init script
cd dotfiles
exec ./macos/init.sh
