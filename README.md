so these are my dotfiles

# install

* `ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/install/master/install)"`
* `sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
* `git clone https://github.com/gaving/dotfiles ~/dotfiles` 
* `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
* `brew install tmux`
* `brew tap homebrew/cask-fonts`
* `brew cask install font-fira-code font-fira-mono-for-powerline font-fira-mono font-fira-sans`

# configure

* `cp ~/dotfiles/.gitconfig.skel ~/.gitconfig`
* `shopt -s extglob`
* `ln -sv ~/dotfiles/.zshrc ~/.oh-my-zsh/custom/entry`
* `ln -sv ~/dotfiles/.!(.|..|git*|zshrc|vim*|vs*) ~/`
* `ln -sv ~/dotfiles/.vscode.settings.json ~/Library/Application\ Support/Code/User/settings.json`
* `ln -sv ~/dotfiles/config ~/.config`
* `ln -sv ~/dotfiles/config/nvim ~/.vim`

# run

* `nvim +PlugInstall +qall`
* `tmux`
* install plugins with `<prefix + I>`