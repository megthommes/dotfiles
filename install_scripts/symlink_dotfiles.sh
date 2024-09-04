# Install dotfiles

echo "Symlinking dotfiles..."

# Install the shell config file
rm -f $HOME/.zshrc
for file in .zshrc .path.sh .env_vars.sh .shortcuts.sh
do
  ln -svf $(pwd)/.files/$file $ZDOTDIR/$file
done

# Install the other dotfiles
mkdir -p $HOME/.ssh
ln -svf $(pwd)/.files/.ssh/config $HOME/.ssh/config
mkdir -p $XDG_CONFIG_HOME/tmux
ln -svf $(pwd)/.files/.tmux.conf $XDG_CONFIG_HOME/tmux/.tmux.conf
ln -svf $(pwd)/.files/.gitconfig $HOME/.gitconfig
ln -svf $(pwd)/.files/prompt_megthommes_setup $ZDOTDIR/prompt_megthommes_setup

# Install scripts
ln -svf "$(pwd)/.scripts" $ZDOTDIR

# Install shell aliases
ln -svf "$(pwd)/.shell_aliases" $ZDOTDIR

# Install plugins
ln -svf "$(pwd)/.plugins" $ZDOTDIR

echo "...dotfiles symlinked."