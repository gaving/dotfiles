#!/bin/zsh
# zsh config

if [ -d ~/.zsh ]; then
    . ~/.zsh/aliases
    . ~/.zsh/config
    [[ -f ~/.zsh/custom ]] && . ~/.zsh/custom
fi
