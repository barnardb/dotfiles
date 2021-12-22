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

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew doctor

# Up-to-date git
brew install git
hash -r  # make the current shell forget old executable locations, so it finds new git

# SSH Key
[ -f ~/.ssh/id_ed25519 ] || [ -f ~/.ssh/id_rsa ] || {
    echo "SSH key not found. Generating one…"
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
}

brew install gh
gh auth login --hostname github.com  # The login / setup process prompts to upload an SSH key

# Clone dotfiles repo
mkdir -p ~/personal
cd ~/personal
[ -d dotfiles/.git ] || git clone git@github.com:barnardb/dotfiles.git

# Run init script
cd dotfiles
./scripts/refresh-working-dir.sh
exec ./macos/init.sh
