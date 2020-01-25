so these are my dotfiles

# install

- `ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/install/master/install)"`
- `sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
- `git clone https://github.com/gaving/dotfiles ~/dotfiles`
- `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- `brew install tmux`

# configure

- `ln -sv ~/dotfiles/.gitconfig ~/.gitconfig`
- `cp ~/dotfiles/.gitconfig.local.example ~/.gitconfig.local`
- `ln -sv ~/dotfiles/.zshrc ~/.oh-my-zsh/custom/entry.zsh`
- `ln -sv ~/dotfiles/config ~/.config`
- `ln -sv ~/dotfiles/config/nvim ~/.vim`
- `shopt -s extglob`
- `ln -sv ~/dotfiles/.!(.|..|git*|zshrc|vim*) ~/`

## omz plugins

- `git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z`
- `git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use`
- `git clone https://github.com/zdharma/history-search-multi-word $ZSH_CUSTOM/plugins/history-search-multi-word`

```bash
plugins=(
  docker
  docker-compose
  extract
  git
  history-search-multi-word
  thefuck
  you-should-use
  zsh-z
)
```

# run

- `nvim +PlugInstall +qall`
- `tmux`
- install plugins with `<prefix + I>`
