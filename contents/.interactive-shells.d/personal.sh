
# Java & Scala fun time
export JAVA_HOME
JAVA_HOME="$(/usr/libexec/java_home --failfast)"
[ $? -eq 0 ] || echo "ERROR while trying to set JAVA_HOME" >&2
export SBT_OPTS="-Dfile.encoding=UTF8 -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256m" #-Xmx2G -XX:ReservedCodeCacheSize=128m -Dscalac.patmat.analysisBudget=512"



# Add cabal to the beginning of the path
export PATH="$HOME/.cabal/bin:$PATH"

# Add personal bin as first in PATH
export PATH="$HOME/bin:$PATH"

# Add DevAut to PATH
export PATH="$PATH:$HOME/personal/devaut/src/main/bash"


# Prevent less from storing state in a home directory dot-file
export LESSHISTFILE=/dev/null


# Use vim
export EDITOR=vim



# enable colour output from ls
export CLICOLOR=1



alias l="ls"
alias ll='ls -la'


if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
