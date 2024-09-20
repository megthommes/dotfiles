# Install dotfiles

echo "Symlinking dotfiles..."

# Install the shell config file
rm -f $HOME/.zshrc
for file in .zshrc .path.sh .env_vars.sh .shortcuts.sh
do
  ln -svf $(pwd)/.files/$file $ZDOTDIR/$file
done

# Install the other dotfiles
ln -svf $(pwd)/.files/.macos $HOME/.macos
mkdir -p $HOME/.ssh
ln -svf $(pwd)/.files/.ssh/config $HOME/.ssh/config
mkdir -p $XDG_CONFIG_HOME/tmux
ln -svf $(pwd)/.files/.tmux.conf $XDG_CONFIG_HOME/tmux/.tmux.conf
ln -svf $(pwd)/.files/.gitconfig $HOME/.gitconfig
ln -svf $(pwd)/.files/.gitignore_global $HOME/.gitignore_global
ln -svf $(pwd)/.files/prompt_megthommes_setup $ZDOTDIR/prompt_megthommes_setup

# create cookiecutter config
GIT_NAME=$(git config --get user.name)
GIT_EMAIL=$(git config --get user.email)
GIT_USERNAME=$(git config --get github.user)
if [ -z "$GIT_NAME" ]; then
    echo "Git user name not set."
    exit 1
fi
if [ -z "$GIT_EMAIL" ]; then
    echo "Git email not set."
    exit 1
fi
if [ -z "$GIT_USERNAME" ]; then
    echo "Git username not set."
    exit 1
fi
touch $COOKIECUTTER_CONFIG
cat <<EOL > "$COOKIECUTTER_CONFIG"
default_context:
  author_name: $GIT_NAME
  author_email: $GIT_EMAIL
  github_username: $GIT_USERNAME
EOL

# Install scripts
ln -svf "$(pwd)/.scripts" $ZDOTDIR

# Install shell aliases
ln -svf "$(pwd)/.shell_aliases" $ZDOTDIR

# Install plugins
ln -svf "$(pwd)/.plugins" $ZDOTDIR

echo "...dotfiles symlinked."
