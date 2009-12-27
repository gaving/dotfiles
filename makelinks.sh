#!/bin/bash

CONFIGS_PATH=$HOME/dotfiles

echo "* Linking files"

for file in .*; do
    if [ ! -e "$HOME/$file" ] && [ $file != ".svn" ]; then
        ln -s "$CONFIGS_PATH/$file" "$HOME/$file";
        echo "* Created:  $HOME/$file";
    fi
done

echo "* Done."
