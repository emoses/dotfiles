#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTDIR=$HOME

if [[ `uname` == "Darwin" ]]
then
    OS=mac
elif [[ `uname -a` =~ Microsoft ]]
then
    OS=win
else
    OS=unix
fi

function make_link () {
    set +e
    if [[ OS == "win" ]]
    then
        mklink $2 $1
    else
        ln -s $1 $2
    fi
    set +e
}


while getopts ":d:" opt; do
    case $opt in
        d)
            INSTDIR=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done
echo "Installing to $INSTDIR"

echo "Linking dotfiles..."
for file in $(ls dot.*)
do
    make_link $DIR/$file $INSTDIR/${file#dot}
done

make_link $DIR/gitignore $INSTDIR/gitignore
mkdir -p $INSTDIR/.emacs.d/straight/versions
make_link $DIR/emacs/straight/versions/default.el $INSTDIR/.emacs.d/straight/versions/default.el
make_link $DIR/emacs/snippets $INSTDIR/.emacs.d/snippets

mkdir $INSTDIR/.lein
if [ ! -e $INSTDIR/.lein/profiles.clj ]
then
   make_link $DIR/profiles.clj $INSTDIR/.lein/profiles.clj
fi

echo "Setting up vim..."
mkdir -p $INSTDIR/.vim/autoload $INSTDIR/.vim/bundle $INSTDIR/.vim/colors
if [ ! -e $INSTDIR/.vim/autoload/pathogen.vim ]
then
    curl -L 'https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim' > $INSTDIR/.vim/autoload/pathogen.vim
fi
if [ ! -e $INSTDIR/.vim/colors/spectro.vim ]
then
    curl -L 'https://github.com/vim-scripts/spectro.vim/raw/master/colors/spectro.vim' > $INSTDIR/.vim/colors/spectro.vim
fi

if [[ "$OS" == "mac" ]]
then
    echo "Detected MacOS, Setting up hammerspoon"
    mkdir $INSTDIR/.hammerspoon
    if [ ! -e $INSTDIR/.hammerspoon/init.lua ]
    then
        make_link $DIR/hammerspoon.lua $INSTDIR/.hammerspoon/init.lua
    fi
    echo "Detected WSL"
else
    echo "No MacOS, Setting up i3"
    XDG=${XDG_CONFIG_HOME:-$INSTDIR/.config}
    mkdir -p $XDG/i3
    if [ ! -e $XDG/i3/config ]
    then
        make_link $DIR/i3config $XDG/i3/config
    fi
fi

echo "Installing python certifi package for emacs support..."
python -m pip install --user certifi

echo "You'll need to install gnutls if it's not already installed."
