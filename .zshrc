#!/bin/zsh
# .zshrc configuration

# {{{ Settings

export ACK_PAGER="less -r"
export COLORTERM=yes
export EDITOR=vim
export HISTFILE=~/.zsh/history
export HISTSIZE=6000
export MANPATH=$HOME/man:$MANPATH
export SAVEHIST=5000
export SPROMPT='...huh? you meant "%r", right? [yn] '
export HOST=${HOST:-$HOSTNAME}

if [[ -x `which lesspipe.sh` ]]; then
    export LESS="-R -M --shift 5"
    export LESSOPEN="|lesspipe.sh %s"
    export LESSCOLOR=1
fi

limit coredumpsize 0
umask 022

PERIOD=3600
periodic() { rehash }

typeset -g -A key
stty pass8
KEYTIMEOUT=1
bindkey -e

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
    hist_reduce_blanks      \
    ignore_eof              \
    list_types              \
    mark_dirs               \
    no_beep                 \
    no_flow_control         \
    notify                  \
    path_dirs               \
    rec_exact               \
    rm_star_silent          \
    share_history

autoload -U compinit && compinit
autoload -U promptinit && promptinit
autoload -U zcalc
autoload -U zmv
autoload -U url-quote-magic && zle -N self-insert url-quote-magic
autoload -U insert-files && zle -N insert-files && bindkey "^Xf" insert-files
autoload -U zsh-mime-setup && zsh-mime-setup
autoload -U edit-command-line && zle -N edit-command-line && bindkey "^Xe" edit-command-line

autoload -U incremental-complete-word predict-on
zle -N incremental-complete-word
zle -N predict-on
zle -N predict-off
bindkey '^XI'  incremental-complete-word
bindkey '^XZ'  predict-on
bindkey '^X^Z' predict-off

for c in cp rm chmod chown rename; do
    alias $c="$c -v"
done

# Load host specific stuff
if [ -d ~/.zsh ]; then
    . ~/.zsh/custom
fi

# Use dircolors where available
if which dircolors > /dev/null; then
    eval $(dircolors -b)
else
    LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=33:so=01;35:bd=01;33:cd=01;33:
    ex=01;32:*.c=36:*.cc=36:*.h=33:*.cmd=01;32:*.exe=01;32:*.com=01;32:
    *.btm=01;32:*.bat=01;32:*.app=01;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:
    *.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:
    *.sit=00;31:*.sitX=00;31:*.zip=00;31:*.bin=00;31:*.hqx=00;31:*.jpg=00;35:
    *.jpeg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.tif=00;35:
    *.tiff=00;35:*.pdf=00;35:*.avi=00;35:*.mov=00;35:*.mpg=00;35:*.mpeg=00;35:
    *.asf=00;35:*.wmv=00;35:*.rm=00;35:*.swf=00;35:*.mp3=00;35:*.aiff=00;35:
    *.aif=00;35:*.snd=00;35:*.wav=00;35:';
    export LS_COLORS
fi
export ZLS_COLORS=$LS_COLORS

# }}}

# {{{ Custom keybindings

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
bindkey '^xw' backward-kill-line
bindkey -s '^Xp' '^Upopd >/dev/null; dirs -v^M'

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
