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
alias gblog="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:red)%(refname:short)%(color:reset) - %(color:yellow)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:blue)%(committerdate:relative)%(color:reset))'"                                                             # git log for each branches

# operations
alias ga='git add'                          # add changes to the staging area
alias gc='git commit -S'                    # commit changes
alias gca='git commit --amend --no-edit -S' # amend the last commit without editing the message
alias gd='git diff'                         # show diff of unstaged changes
# checkout branch or create it if it doesn't exist
alias gco='f() { git checkout -b "$1" 2> /dev/null || git checkout "$1"; }; f'
alias gsub="git submodule update --remote"  # pull submodules
alias gclone="git clone --recursive"        # clone repository including all submodules

# branch management
alias gb='git branch '     # list or manipulate branches
alias gbr='git branch -r'  # list remote branches
alias gba='git branch -a'  # list all branches (local and remote)
alias gf='git fetch'       # fetch changes from remote repository
# delete local branch merged with main
alias gclean="git fetch --all --prune; git branch --merged | grep  -v '\\*\\|main\\|develop' | xargs -n 1 git branch -d"

# push and pull
alias gps='git push'                       # push changes to remote repository
alias gpl='git pull  --recurse-submodules' # pull changes from remote repository and update submodules