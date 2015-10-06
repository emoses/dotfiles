#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Linking dotfiles..."
for file in $(ls dot.*)
do
    ln -s $DIR/$file $HOME/${file#dot}
done

ln -s $DIR/gitignore $HOME/gitignore

mkdir $HOME/.lein
if [ ! -e $HOME/.lein/profiles.clj ]
then
   ln -s $DIR/profiles.clj $HOME/.lein/profiles.clj
fi

echo "Setting up vim..."
mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle $HOME/.vim/colors
if [ ! -e $HOME/.vim/autoload/pathogen.vim ] 
then
    curl -L 'https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim' > $HOME/.vim/autoload/pathogen.vim
fi
if [ ! -e $HOME/.vim/colors/spectro.vim ]
then
    curl -L 'https://github.com/vim-scripts/spectro.vim/raw/master/colors/spectro.vim' > $HOME/.vim/colors/spectro.vim
fi

if [[ `uname` == "Darwin" ]]
then
    echo "Detected MacOS, Setting up hammerspoon"
    mkdir $HOME/.hammerspoon
    if [ ! -e $HOME/.hammerspoon/init.lua ]
    then 
        ln -s $DIR/hammerspoon.lua $HOME/.hammerspoon/init.lua
    fi
fi

