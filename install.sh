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

# backup-and-link asset dest
backup-and-link()
{
    if [ -f $2 ] && [ ! -L $2 ]; then
        mv $2{,.bak}
    fi
    ln -sf $1 $2
}

if [ ! -d ~/.oh-my-zsh ]; then
    echo "Installing oh-my-zsh"
    curl -kL https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

echo "Installing zsh-syntax-highlighting"
mkdir -p ~/.oh-my-zsh/custom/plugins
clone-or-pull git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo "Installing RC files"
for path in ~/.pEnv/assets/rcs/*
do
    name=$(basename $path)
    backup-and-link $path ~/.$name
done

echo "Installing Vundle"
mkdir -p ~/.vim/bundle
clone-or-pull https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo "Vundling vim plugins"
vim +BundleInstall! +qall

echo "Installing custom vim filetypes"
backup-and-link ~/.pEnv/assets/filetype.vim ~/.vim/filetype.vim

echo "Installation complete!"
