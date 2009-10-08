#!/bin/zsh
# .zshrc configuration

# {{{ Settings

export CC=gcc
export COLORTERM=yes
export EDITOR=vim
export HISTFILE=~/.zsh/history
export HISTSIZE=6000
export MANPATH=$HOME/man:$MANPATH
export SAVEHIST=5000
export SPROMPT='...you meant %r, right? [yn] '
export HOST=${HOST:-$HOSTNAME}

limit coredumpsize 0
umask 022

PERIOD=3600
periodic() { rehash }

setopt \
    auto_cd                 \
    auto_name_dirs          \
    auto_pushd              \
    braceccl                \
    chase_links             \
    clobber                 \
    complete_aliases        \
    correctall              \
    extended_glob           \
    hist_ignore_all_dups    \
    hist_ignore_space       \
    ignore_eof              \
    no_flow_control         \
    notify                  \
    list_types              \
    mark_dirs               \
    path_dirs               \
    rm_star_silent

autoload -U compinit && compinit
autoload -U promptinit && promptinit
autoload -U zcalc
autoload -U zmv
autoload -U url-quote-magic && zle -N self-insert url-quote-magic
autoload -U tetris && zle -N tetris && bindkey "^T" tetris

autoload -U incremental-complete-word predict-on
zle -N incremental-complete-word
zle -N predict-on
zle -N predict-off
bindkey '^XI'  incremental-complete-word
bindkey '^XZ'  predict-on
bindkey '^X^Z' predict-off

autoload -U insert-files
zle -N insert-files
bindkey "^Xf" insert-files

# Custom environmental variables
if [ -d ~/.zsh ]; then
    . ~/.zsh/custom
fi

# if [[ -x $(where dircolors) ]]; then
    # eval  $(dircolors -b)
    # export ZLS_COLORS=$LS_COLORS
# fi

# }}}

# {{{ Keybindings

typeset -g -A key

stty pass8
KEYTIMEOUT=1

bindkey -e

bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[8~' end-of-line
bindkey '^[OF' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
bindkey '^[[D' backward-char
bindkey '^Q' push-line
bindkey '^[a' beginning-of-line
bindkey '^[e' end-of-line
bindkey "^@"  _history-complete-older

# interactive editing of command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey "\ee" edit-command-line

# }}}

# {{{ Files

if [ -d ~/.zsh ]; then
    . ~/.zsh/aliases
    . ~/.zsh/completion
    . ~/.zsh/functions
fi

# }}}

# {{{ Title

watch=notme
WATCHFMT="[%B%t%b] %B%n%b has %a %B%l%b from %B%M%b"

precmd() {
    title zsh "$PWD"
}

preexec() {
    emulate -L zsh
    local -a cmd; cmd=(${(z)1})
    title $cmd[1]:t "$cmd[2,-1]"
}

title() {
    if [[ $TERM == "screen" ]]; then
        # set hard status to last used command
        # and main window title to the current directory
        print -n "\eP\e]0;${@}\C-G\e\\"
        print -nR $'\033k'$1$'\033'\\

        #print -nR $'\033]0;'$2$'\a'
    elif [[ $TERM == "xterm" || $TERM == "rxvt" || $TERM == "rxvt-unicode" ]]; then
        # use this one instead for xterms:
        print -nR $'\033]0;'$*$'\a'
    fi
}

# }}}
