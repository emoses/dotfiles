#!/bin/bash

echo "Linking dotfiles..."
for file in $(ls dot.*)
do
    ln -s $file $HOME/${file#dot}
done
