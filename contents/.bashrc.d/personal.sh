shopt -s autocd
shopt -s checkjobs
shopt -s checkwinsize
shopt -s dirspell
shopt -s histappend
shopt -s no_empty_cmd_completion

function setWindowTitle {
    # Escape backslashes, unless we're trying to display \W (working dir in PS1)
    local title
    if [ "$*" = "\W" ]; then
        title="$*"
    else
        title="$(printf %s "$*" | sed 's/\\/\\\\/g' | head -n 1)"
    fi
    echo -en "\033]0;$title\007"
}
setWindowTitle "loading..."

# Keep more than 500 lines of history
HISTSIZE=2048

# Use built-in python class to serve current directory over HTTP on port 8000
# with UTF-8 encoding
function serve() (
    if [ $# = 1 ]; then
        cd "$1"
    elif [ $# != 0 ]; then
        echo "usage: serve [DIR]" >&2
        return 1
    fi
    python -c "import SimpleHTTPServer; m = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map; m[''] = 'text/plain'; m.update(dict([(k, v + ';charset=UTF-8') for k, v in m.items()])); SimpleHTTPServer.test();"
)

# Making it easier to move up in the world
alias -- ..='cd ..'
alias -- ...='.. && ..'
alias -- ....='... && ..'
alias -- .....='.... && ..'
alias -- ......='..... && ..'
alias -- .......='...... && ..'
alias -- ........='....... && ..'

# Have tree output Unicode characters properly
alias tree="tree -N"

# Cause . without args to print the working directory instead of an error
function . {
    if [ $# = 0 ]; then
        pwd
    else
        builtin . "$@"
    fi
}

# Announce exit status of the current or previous command
function announce {
    local exit_status=$?
    if [ $# -gt 0 ]; then
        exit_status=0
        "$@" || exit_status=$?
    fi
    nohup say -v anna "$(if [ "${exit_status}" -eq 0 ]; then printf "Erfolgreich abgeschlossen"; else printf "Fehlerstatus %s" "${exit_status}"; fi)" &>/dev/null &
    #say "$([$exit_status -eq 0] && printf "Success" || printf "Failure, exit status %s" $exit_status)" &
    return $exit_status
}

# Enable bash completion
brew_prefix="$(brew --prefix)"
if [ -f "$brew_prefix/etc/bash_completion" ]; then
    . "$brew_prefix/etc/bash_completion"
else
    echo "Can't find bash-completion!" >&2
fi
unset brew_prefix

# Set the prompt
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=verbose

PROMPT_COMMAND='EXIT_STATUS=$?;'

# append to history after each command
PROMPT_COMMAND="$PROMPT_COMMAND history -a;"

PS1=$(
    RED='\033[31m'
    GREEN='\033[32m'
    LT_BLUE='\033[036m'
    RESET='\033[0m'
    SET_MARK='\[\033]50;SetMark\007\]'

    TAB_TITLE="\[$(setWindowTitle \\W)\]"
    PATH_COMPONENT="\[${LT_BLUE}\]\W\[${RESET}\]"
    EXIT_STATUS="\$((exit \$EXIT_STATUS) && echo 0 || echo -e \[${RED}\]\$?\[${RESET}\])"
    GIT_COMPONENT="\$(__git_ps1 ' (%s)')"

    echo -n "$SET_MARK$TAB_TITLE$PATH_COMPONENT$GIT_COMPONENT $EXIT_STATUS \\$ "
)
