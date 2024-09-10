# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# editor
export EDITOR="micro"
export VISUAL="micro"

# ZSH
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"    # history filepath
export HISTSIZE='32768';                # increase history size (default=500)
export HISTFILESIZE="${HISTSIZE}";
export SAVEHIST="${HISTSIZE}";
export HISTCONTROL='ignoreboth';        # omit duplicates and commands that begin with a space from history

# homebrew
if [ -z "${HOMEBREW_PREFIX}" ]; then
    # Check for Intel Mac
    if [ -d "/usr/local/Homebrew" ]; then
        export HOMEBREW_PREFIX="/usr/local"
    # Check for Apple Silicon Mac
    elif [ -d "/opt/homebrew" ]; then
        export HOMEBREW_PREFIX="/opt/homebrew"
    else
        echo "Homebrew installation not found"
    fi
fi

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'