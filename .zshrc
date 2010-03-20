#!/bin/zsh
# zsh config

if [ -d ~/.zsh ]; then
    . ~/.zsh/config
    . ~/.zsh/aliases
    . ~/.zsh/completion
    . ~/.zsh/theme
    [[ -f ~/.zsh/custom ]] && . ~/.zsh/custom
fi
