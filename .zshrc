#!/bin/zsh
# zsh config

if [ -d ~/.zsh ]; then
    . ~/.zsh/config
    . ~/.zsh/aliases
    [[ -f ~/.zsh/custom ]] && . ~/.zsh/custom
fi
