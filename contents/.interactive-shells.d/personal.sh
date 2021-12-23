
# Add utilities to the PATH
export PATH="$PATH:$HOME/personal/dotfiles/utilities"

# Add DevAut to PATH
export PATH="$PATH:$HOME/personal/devaut/src/main/bash"


# Use vim
export EDITOR=vim


# enable colour output from commands like ls
export CLICOLOR=1


alias l="ls"
alias la='ls -a'
alias ll='ls -la'


# Making it easier to move up in the world
alias -- ..='cd ..'
alias -- ...='.. && ..'
alias -- ....='... && ..'
alias -- .....='.... && ..'
alias -- ......='..... && ..'
alias -- .......='...... && ..'
alias -- ........='....... && ..'


# Cause . without args to print the working directory instead of an error
function . {
    if [ $# = 0 ]; then
        pwd
    else
        builtin . "$@"
    fi
}
