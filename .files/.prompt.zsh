#!/bin/zsh
# Personalized prompt

# Based on:
# Purity
# by Kevin Lanni
# https://github.com/therealklanni/purity
# MIT License
# and
# Purification
# by Matthieu Cneude
# https://github.com/Phantas0s/purification

# git:
# %b => current branch
# %a => current action (rebase/merge)

# prompt:
# %F => color dict
# %f => reset color
# %B => bold
# %b => reset bold
# %K => background color
# %k => reset background color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

# turns seconds into human readable time
prompt_human_time() {
  local tmp=$1
  local days=$(( tmp / 60 / 60 / 24 ))
  local hours=$(( tmp / 60 / 60 % 24 ))
  local minutes=$(( tmp / 60 % 60 ))
  local seconds=$(( tmp % 60 ))
  echo -n "⌚︎ "
  (( $days > 0 )) && echo -n "${days}d "
  (( $hours > 0 )) && echo -n "${hours}h "
  (( $minutes > 0 )) && echo -n "${minutes}m "
  echo "${seconds}s"
}

# displays the exec time of the last command if set threshold was exceeded
prompt_cmd_exec_time() {
  local stop=$EPOCHSECONDS
  local start=${cmd_timestamp:-$stop}
  integer elapsed=$stop-$start
  (($elapsed > 5)) && prompt_human_time $elapsed
}

# string length ignoring ansi escapes
prompt_string_length() {
  echo ${#${(S%%)1//(\%([KF1]|)\{*\}|\%[Bbkf])}}
}

# display git branch
prompt_git_branch() {
  autoload -Uz vcs_info
  precmd_vcs_info() { vcs_info }
  precmd_functions+=( precmd_vcs_info )
  setopt prompt_subst
  zstyle ':vcs_info:git:*' formats '%b'
}

# display git info
prompt_git_info() {
  if [ -n "$vcs_info_msg_0_" ]; then
    if [ "$vcs_info_msg_0_" = "main" ]; then
      echo "%B%K{cyan}$vcs_info_msg_0_%k%b"
    else
      echo "%B%F{cyan}$vcs_info_msg_0_%f%b"
    fi
  fi
}

# helper function for get_git_[file,branch]_status
check_git_status() {
  local git_status_output="$1"
  local git_status_pattern="$2"
  local git_status_format="$3"

  if echo "$git_status_output" | grep -q "$git_status_pattern"; then
    echo "$git_status_format"
  else
    echo ""
  fi
}

# display git status
prompt_git_file_status() {
  local git_status_output
  git_status_output=$(command git status --porcelain -b 2> /dev/null) || {
    echo "[Error: Unable to retrieve Git status]"
    return
  }

  # icons and colors as associative arrays
  local -A icons=(
    ["added"]="+"
    ["modified"]="★"
    ["deleted"]="-"
    ["renamed"]="↻"
    ["unmerged"]="⚠"
    ["untracked"]="?"
  )
  local -A colors=(
    ["staged"]="green"
    ["unstaged"]="blue"
    ["both"]="yellow"
  )

  # Temporary status variables
  local staged_added=""
  local unstaged_added=""
  local staged_modified=""
  local unstaged_modified=""
  local modified_both=""
  local staged_deleted=""
  local unstaged_deleted=""
  local staged_renamed=""
  local unstaged_renamed=""
  local unmerged=""
  local untracked=""

  # Check statuses
  # added
  staged_added="$(check_git_status "$git_status_output" '^A. ' "%F{${colors[staged]}}${icons[added]}%f")"
  unstaged_added="$(check_git_status "$git_status_output" '^.A ' "%F{${colors[unstaged]}}${icons[added]}%f")"
  local status_added=""
  for f_status in "$staged_added" "$unstaged_added"; do
    if [ -n "$f_status" ]; then
      status_added+="$f_status"
    fi
  done
  # modified
  staged_modified="$(check_git_status "$git_status_output" '^M[^M]* ' "%F{${colors[staged]}}${icons[modified]}%f")"
  unstaged_modified="$(check_git_status "$git_status_output" '^[^M\s].*M ' "%F{${colors[unstaged]}}${icons[modified]}%f")"
  modified_both="$(check_git_status "$git_status_output" '^MM ' "%F{${colors[both]}}${icons[modified]}%f")"
  local status_modified=""
  for f_status in "$staged_modified" "$unstaged_modified" "$modified_both"; do
    if [ -n "$f_status" ]; then
      status_modified+="$f_status"
    fi
  done
  # deleted
  staged_deleted="$(check_git_status "$git_status_output" '^D. ' "%F{${colors[staged]}}${icons[deleted]}%f")"
  unstaged_deleted="$(check_git_status "$git_status_output" '^.D ' "%F{${colors[unstaged]}}${icons[deleted]}%f")"
  local status_deleted=""
  for f_status in "$staged_deleted" "$unstaged_deleted"; do
    if [ -n "$f_status" ]; then
      status_deleted+="$f_status"
    fi
  done
  # renamed
  staged_renamed="$(check_git_status "$git_status_output" '^R. ' "%F{${colors[staged]}}${icons[renamed]}%f")"
  unstaged_renamed="$(check_git_status "$git_status_output" '^.R ' "%F{${colors[unstaged]}}${icons[renamed]}%f")"
  local status_renamed=""
  for f_status in "$staged_renamed" "$unstaged_renamed"; do
    if [ -n "$f_status" ]; then
      status_renamed+="$f_status"
    fi
  done
  # unmerged
  status_unmerged="$(check_git_status "$git_status_output" '^UU ' "%F{${colors[both]}}${icons[unmerged]}%f")"
  # untracked
  status_untracked="$(check_git_status "$git_status_output" '^\?\? ' "%F{${colors[both]}}${icons[untracked]}%f")"

  # Combine statuses with spaces
  local file_status=""
  for f_status in "$status_added" "$status_modified" "$status_deleted" "$status_renamed" "$status_unmerged" "$status_untracked"; do
    if [ -n "$f_status" ]; then
      file_status+="$f_status "
    fi
  done

  # Trim trailing space
  file_status="${file_status% }"

  if [ -n "$file_status" ]; then
    echo "[ %B$file_status%b ]"
  fi
}


# path
prompt_path() {
  local current_path=$(pwd)
  current_path="${current_path/#$HOME/~}"

  if command git rev-parse --is-inside-work-tree &> /dev/null; then
    local git_root=$(basename $(git rev-parse --show-toplevel))
    current_path="$git_root${current_path#*$git_root}"
  fi

  echo "%F{white}$current_path%f"
}

# get venv name
get_venv_name() {
  if [ -n "$VIRTUAL_ENV" ]; then
    # Check if .venv/pyvenv.cfg exists
    local cfg_file="$VIRTUAL_ENV/pyvenv.cfg"
    local venv_name=""
    if [ -f "$cfg_file" ]; then
      # Extract the prompt from the config file
      venv_name=$(grep -E '^prompt ?=' "$cfg_file" | cut -d'=' -f2-)
      echo "$venv_name"
    else
      # Fall back to basename of the virtual environment directory
      venv_name=$(basename "$VIRTUAL_ENV")
      if [[ "$venv_name" == ".venv" ]]; then
        venv_name="venv"
      fi
      echo "$venv_name"
    fi
  fi
}

prompt_venv() {
  local VENV_NAME=$(get_venv_name)
  if [[ -n "$VENV_NAME" ]]; then
    echo "%F{magenta}$VENV_NAME%f"
  fi
}

prompt_precmd() {
  # shows the full path in the title
  print -Pn '\e]0;%~\a'

  local preprompt="$(prompt_path) $(prompt_git_branch) $(prompt_git_file_status)"

  # only print execution time if it's non-empty
  local exec_time=$(prompt_cmd_exec_time)
  [[ -n "$exec_time" ]] && print -P '%F{yellow}${exec_time}%f'

  # check async if there is anything to pull
  # check if we're in a git repo
  if command git rev-parse --is-inside-work-tree &>/dev/null; then
    # check if there is anything to pull
    if command git fetch &>/dev/null && command git rev-parse --abbrev-ref @'{u}' &>/dev/null; then
      if (( $(command git rev-list --right-only --count HEAD...@'{u}' 2>/dev/null) > 0 )); then
        # some crazy ansi magic to inject the symbol into the previous line
        print -Pn "\e7\e[0G\e[`prompt_string_length $preprompt`C%F{cyan}⇣%f\e8"
      fi
    fi
  fi

  # reset value since `preexec` isn't always triggered
  unset cmd_timestamp
}

prompt_preexec() {
  cmd_timestamp=$EPOCHSECONDS

  # shows the current dir and executed command in the title when a process is active
  print -Pn "\e]0;"
  echo -nE "$PWD:t: $2"
  print -Pn "\a"
}

prompt_setup() {
  # prevent % showing up if output doesn't end with a newline
  export PROMPT_EOL_MARK=''

  # set prompt options
  prompt_opts=(cr subst percent)

  # load zsh modules and functions
  zmodload zsh/datetime # datetime module
  autoload -Uz add-zsh-hook # add-zsh-hook function
  autoload -Uz vcs_info # vcs_info function

  # add hooks
  add-zsh-hook precmd prompt_precmd # pre-prompt
  add-zsh-hook preexec prompt_preexec # pre-execution

  # define prompt
  prompt_git_branch
  PROMPT='$(prompt_path) $(prompt_git_info) $(prompt_git_file_status) %(?.%B%F{green}.%B%F{red})❯%f%b '
  RPROMPT='$(prompt_venv)'
}

prompt_setup "$@"
