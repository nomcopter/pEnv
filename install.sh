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
    if [ -e $2 ] && [ ! -L $2 ]; then
        mv $2{,.bak}
    fi
    rm -f $2
    ln -s $1 $2
}

if [ ! -d ~/.oh-my-zsh ]; then
    echo
    echo "Installing oh-my-zsh..."
    curl -kL https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

echo
echo "Installing zsh-syntax-highlighting..."
mkdir -p ~/.oh-my-zsh/custom/plugins
clone-or-pull https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

if [ ! -f ~/.pEnv/assets/rcs/gitconfig ]; then
    echo
    echo "Setting up Git..."
    echo "Enter your personal information for commits"
    read -p " Name: " name
    read -p "Email: " email
    sed -e "s/{{NAME}}/$name/" -e "s/{{EMAIL}}/$email/" ~/.pEnv/assets/gitconfig.template > ~/.pEnv/assets/rcs/gitconfig
fi

echo
echo "Installing RC files..."
for path in ~/.pEnv/assets/rcs/*
do
    name=$(basename $path)
    backup-and-link $path ~/.$name
done

echo
echo "Setting up fonts..."
backup-and-link ~/.pEnv/assets/fonts ~/.fonts
fc-cache -vf ~/.fonts
mkdir -p ~/.config/fontconfig/conf.d/
backup-and-link ~/.pEnv/assets/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/10-powerline-symbols.conf
mkdir -p ~/.fonts.conf.d/
backup-and-link ~/.pEnv/assets/10-powerline-symbols.conf ~/.fonts.conf.d/10-powerline-symbols.conf

echo
echo "Installing Vundle..."
mkdir -p ~/.vim/bundle
clone-or-pull https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo
echo "Vundling vim plugins..."
vim +BundleInstall! +qall

echo
echo "Installing custom vim filetypes..."
backup-and-link ~/.pEnv/assets/filetype.vim ~/.vim/filetype.vim

echo
echo "Setting up ROXTerm..."
backup-and-link ~/.pEnv/assets/roxterm  ~/.config/roxterm.sourceforge.net

echo
echo "Installation complete!"
echo "It is recommended to install zsh, tmux v1.8+, and roxterm if they are not already"
