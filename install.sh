#!/bin/bash

# clone-or-pull repo-location folder-destination
clone-or-pull() 
{
    if [ -d $2 ]; then
        echo "Plugin already installed, updating..."
        cd $2
        git pull
    else
        git clone $1 $2
    fi
}

echo "Installing oh-my-zsh"
curl -kL https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

mkdir -p ~/.oh-my-zsh/custom/plugins
clone-or-pull git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo "Installing pathogen.vim"
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -kso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

echo "Installing nerdtree.vim"
clone-or-pull https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree.git

# solarized.vim
echo "Installing solarized.vim"
clone-or-pull git://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized.git

echo "Installing RC files"
for path in ~/.pEnv/assets/*
do
    name=$(basename $path)
    if [ -f ~/.$name ]; then
        mv ~/.$name{,.bak}
    fi
    ln -sf $path ~/.$name
done

echo "Installation complete!"
