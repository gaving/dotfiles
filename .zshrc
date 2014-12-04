#!/bin/zsh
# zsh config

if [ -d ~/.zsh ]; then
    . ~/.zsh/config
    . ~/.zsh/aliases
    . ~/.zsh/completion
    [[ -f ~/.zsh/custom ]] && . ~/.zsh/custom
    . ~/.zsh/theme
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.z.sh ] && source ~/.z.sh
