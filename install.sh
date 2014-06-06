#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Linking dotfiles..."
for file in $(ls dot.*)
do
    ln -s $DIR/$file $HOME/${file#dot}
done
ln -s $DIR/gitignore $HOME/gitignore
echo "Setting up vim..."
mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle $HOME/.vim/colors
if [ ! -e $HOME/.vim/autoload/pathogen.vim ] 
then
    curl 'www.vim.org/scripts/download_script.php?src_id=21650' > /tmp/pathogen.zip
    unzip /tmp/pathogen.zip -d $HOME/.vim/
    rm /tmp/pathogen.zip
fi
if [ ! -e $HOME/.vim/colors/spectro.vim ]
then
    curl 'http://www.vim.org/scripts/download_script.php?src_id=5356' > $HOME/.vim/colors/spectro.vim
fi

