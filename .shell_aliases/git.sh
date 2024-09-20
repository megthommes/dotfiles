#!/bin/bash

# status and information
alias gs='git status'         # show status of working directory and staging area
alias gss='git status -s'     # `gs` in short format
alias gpraise='git blame'     # show who last modified each line of a file
alias gl='git log --oneline'  # show commit history
alias gr='git remote'         # show remote repositories
alias grs='git remote show'   # show information about remote repositories
# show a graph of the commit history
alias glol='git log --graph --abbrev-commit --oneline --decorate'
# show git log for each branch
alias gblog='git for-each-ref \
  --sort=committerdate \
  refs/heads/ \
  --format='\''%(HEAD) %(color:red)%(refname:short)%(color:reset) - \
%(color:yellow)%(objectname:short)%(color:reset) - \
%(contents:subject) - \
%(authorname) \
(%(color:blue)%(committerdate:relative)%(color:reset))'\'

# operations
alias ga='git add'                          # add changes to the staging area
alias gc='git commit -S'                    # commit changes
alias gca='git commit --amend --no-edit -S' # amend the last commit without editing the message
alias gd='git diff'                         # show diff of unstaged changes
# checkout branch or create it if it doesn't exist
alias gco='f() { git checkout -b "$1" 2>/dev/null || git checkout "$1"; }; f'
alias gsub='git submodule update --remote'  # pull submodules
alias gclone='git clone --recursive'        # clone repository including all submodules
alias gps='git push'                        # push changes to remote repository
alias gpl='git pull'                        # pull changes from remote repository and update submodules

# branch management
alias gb='git branch '     # list or manipulate branches
alias gbr='git branch -r'  # list remote branches
alias gba='git branch -a'  # list all branches (local and remote)
alias gf='git fetch'       # fetch changes from remote repository
# delete local branch merged with main
alias gclean='
  original_branch=$(git rev-parse --abbrev-ref HEAD)
  protected_branches="main $original_branch"

  if ! git diff --quiet || ! git diff --staged --quiet; then
    stash_name="gclean_$(date +%s)"
    git stash push -q -m "$stash_name" || echo "Error: Failed to stash changes"
    stashed=true
  else
    stashed=false
  fi

  git fetch --all --prune

  git for-each-ref --format="%(refname:short) %(upstream:track)" refs/heads/ |
  while read -r branch track; do
    if ! echo "$protected_branches" | grep -q "\b$branch\b"; then
      if [ "$track" = "[gone]" ] || [ -z "$track" ]; then
        if [ -n "$(git diff main..$branch)" ]; then
          echo "Branch $branch has unpushed commits. Skipping."
        else
          echo "Deleting branch: $branch"
          git branch -D "$branch" 2>/dev/null || echo "Could not delete $branch"
        fi
      fi
    fi
  done

  git remote prune origin

  if [ "$stashed" = true ]; then
    stash_index=$(git stash list | grep -n "$stash_name" | cut -d: -f1)
    if [ -n "$stash_index" ]; then
        stash_index=$((stash_index - 1))
        git stash pop -q "stash@{${stash_index}}" || echo "Error: Failed to pop stash"
    else
        echo "Warning: gclean_stash not found in stash list"
    fi
  fi
'
