#!/bin/sh
set -euo pipefail
set -x

# Computer Name
computer_name="$(scutil --get ComputerName)"
read -er -p "Give this computer a name [${computer_name}]: "
[ -z "$REPLY" ] || {
    computer_name="$REPLY"
    sudo systemsetup -setcomputername "${computer_name}"
    sudo systemsetup -setlocalsubnetname "${computer_name}"
}

# SSH Key
[ -f ~/.ssh/id_rsa ] || {
    echo "SSH key not found. Let's generate one and upload it to GitHub."
    read -er -p "GitHub username [$USER]: "
    [ -n "$REPLY" ] || REPLY="$USER"
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
    curl --fail --include --user "$REPLY" -p -d "{\"title\":\"$USER@${computer_name}\", \"key\":\"$(cat ~/.ssh/id_rsa.pub)\"}" https://api.github.com/user/keys
}

# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor

# Up-to-date git
brew install git
hash -r  # make the current shell forget old executable locations, so it finds new git

# Clone dotfiles repo
mkdir -p ~/personal
cd ~/personal
-d dotfiles/.git || git clone git@github.com:barnardb/dotfiles.git

# Run init script
cd dotfiles
exec ./macos/init.sh
