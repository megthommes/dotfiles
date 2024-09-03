# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# aliases
for alias_file in $ZDOTDIR/.shell_aliases/*.zsh; do
    source "$alias_file"
done

# navigation
setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

# scripts
for script_file in $ZDOTDIR/.scripts/*.zsh; do
    source "$script_file"
done

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
for plugin_dir in $ZDOTDIR/.plugins/*(/); do
    if [[ -f "$plugin_dir/${plugin_dir:t}.*.zsh" ]]; then
        source "$plugin_dir/${plugin_dir:t}.*.zsh"
    elif [[ -f "$plugin_dir/${plugin_dir:t}.zsh" ]]; then
        source "$plugin_dir/${plugin_dir:t}.zsh"
    fi
done

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

# direnv
eval "$(direnv hook zsh)"
