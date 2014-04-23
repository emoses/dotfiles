#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Linking dotfiles..."
for file in $(ls dot.*)
do
    ln -s $DIR/$file $HOME/${file#dot}
done
