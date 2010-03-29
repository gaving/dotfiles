#!/bin/zsh
# zsh config

if [ -d ~/.zsh ]; then
    . ~/.zsh/config
    . ~/.zsh/aliases
    . ~/.zsh/completion
    [[ -f ~/.zsh/custom ]] && . ~/.zsh/custom
    . ~/.zsh/theme
fi
