# aliases
for alias_file in "$ZDOTDIR"/.shell_aliases/*.sh; do
    source "$alias_file"
done

# environment variables
source "$ZDOTDIR/.env_vars.sh"

# navigation
setopt AUTO_CD              # Change directory without cd.
setopt CORRECT              # Spelling correction.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

# shortcuts
source "$ZDOTDIR/.shortcuts.sh"

# scripts
for script_file in "$ZDOTDIR"/.scripts/*.zsh; do
    source "$script_file"
done

# prompt
fpath=("$ZDOTDIR/prompt_megthommes_setup" $fpath)
source "$ZDOTDIR/prompt_megthommes_setup"

# history
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt INC_APPEND_HISTORY        # Append to history immediately instead of at the end of the session.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# plugins
source "$ZDOTDIR/.plugins/completion.zsh"
for plugin_dir in "$ZDOTDIR"/.plugins/*(/); do
    if [[ ${plugin_dir:t} == "zsh-completions" ]]; then
        fpath=("$plugin_dir/src" $fpath)
    elif [[ -f "$plugin_dir/${plugin_dir:t}.*.zsh" ]]; then
        source "$plugin_dir/${plugin_dir:t}.*.zsh"
    elif [[ -f "$plugin_dir/${plugin_dir:t}.zsh" ]]; then
        source "$plugin_dir/${plugin_dir:t}.zsh"
    fi
done

# Set up key bindings for completion
bindkey '^[[Z' autosuggest-accept # Shift+Tab

# direnv
eval "$(direnv hook zsh)"
