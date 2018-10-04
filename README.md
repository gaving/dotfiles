so these are my dotfiles

# install

* `ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/install/master/install)"`
* `sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`

* `git clone https://github.com/gaving/dotfiles ~/dotfiles` 
* `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

* `brew install tmux`

# configure

* `shopt -s extglob`
* `ln -sv ~/dotfiles/.zshrc ~/.oh-my-zsh/custom/entry`
* `ln -sv dotfiles/.!(.|..|git*|zshrc|vs*) ~/`

# run

* `tmux`
* install plugins with `<prefix + I>`