# ~/.*

so these are my dotfiles

## install

- `ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/install/master/install)"`
- `sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
- `git clone https://github.com/gaving/dotfiles ~/dotfiles`
- `ln -sv ~/dotfiles ~/.config`
- `git clone https://github.com/tmux-plugins/tpm $XDG_DATA_HOME/tmux/plugins/tpm`
- `brew install tmux`

## configure

- `ln -sv ~/.config/zsh/.zshenv`
- `cp ~/.config/git/local.example ~/.config/git/local`
- `ln -sv ~/.config/zsh/user ~/.oh-my-zsh/custom/entry.zsh`
- `git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1`
- `ln -sv ~/.config/nvchad ~/Dotfiles/nvim/lua/custom`

### plugins

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

## run

- `nvim +PlugInstall +qall`
- `tmux`
- install plugins with `<prefix + I>`
