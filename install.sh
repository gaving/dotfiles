#!/bin/sh

DOMAIN=http://brokentrain.net/dotfiles.tar.gz
HOME=/tmp/.gavin
export HOME
mkdir -p "$HOME" || exit 1

if [ -x "`which curl`" ]; then
    get="curl -Ls"
else
    get="wget -qO -"
fi

$get $DOMAIN|gzip -dc|tar xf - -C "$HOME"

cat > "$HOME/.screenrc.home" <<-EOF
setenv HOME "$HOME"
source "$HOME/.screenrc"
EOF

for shell in /bin/bash /usr/bin/zsh /bin/zsh; do
    [ -x $shell ] && SHELL=$shell
done
export SHELL

tty=`tty <&2`
if [ "$#" -gt 0 ]; then
    exec "$@" <"$tty"
#elif [ "`uname`" = Darwin -a /usr/bin/screen = "`which screen 2>/dev/null`" ]; then
    # the screen shipped with OS X is broken
    #exec $SHELL <"$tty"
elif [ -z "$STY" -a -x "`which screen 2>/dev/null`" ]; then
    exec /usr/bin/screen -c "$HOME/.screenrc.home" -xRR gavin <"$tty"
else
    exec $SHELL <"$tty"
fi
