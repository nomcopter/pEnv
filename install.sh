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

echo "Installing RC files"
for path in ~/.pEnv/assets/*
do
    name=$(basename $path)
    if [ -f ~/.$name ]; then
        mv ~/.$name{,.bak}
    fi
    ln -sf $path ~/.$name
done

echo "Installing Vundle"
mkdir -p ~/.vim/bundle
clone-or-pull https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo "Vundling vim plugins"
vim +BundleInstall +qall

echo "Installation complete!"
