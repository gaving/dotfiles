#!/bin/zsh
# zsh config

if [ -d ~/.zsh ]; then
    . ~/.zsh/config
    . ~/.zsh/aliases
    . ~/.zsh/completion
    [[ -f ~/.zsh/custom ]] && . ~/.zsh/custom
    [ -f ~gavin/sandbox/zsh-git-prompt/zshrc.sh ] && source ~gavin/sandbox/zsh-git-prompt/zshrc.sh
    . ~/.zsh/theme
fi

[ -f ~/.fzf/shell/completion.zsh ] && source ~/.fzf/shell/completion.zsh
# [ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh
[ -f ~/.z.sh ] && source ~/.z.sh

# PROMPT='%B%m%~%b$(git_super_status) %# '
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
