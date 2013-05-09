#!/bin/bash

# oh-my-zsh
echo "Installing oh-my-zsh"
curl -kL https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

mkdir -p ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# pathogen.vim
echo "Installing pathogen.vim"
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -kso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

# nerdtree.vim
echo "Installing nerdtree.vim"
if [ -d ~/.vim/bundle/nerdtree.git ]; then
    echo "Plugin already installed, updating..."
    cd ~/.vim/bundle/nerdtree.git
    git pull
    cd - > /dev/null
else
    git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree.git
fi

# solarized.vim
echo "Installing solarized.vim"
if [ -d ~/.vim/bundle/vim-colors-solarized.git ]; then
    echo "Plugin already installed, updating..."
    cd ~/.vim/bundle/vim-colors-solarized.git
    git pull
    cd - > /dev/null
else
    git clone git://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized.git
fi

echo "Installing RC files"
for rc in vimrc tmux.conf zshrc bashrc
do
  if [ -f ~/.$rc ]; then
    mv ~/.$rc{,.bak}
  fi
  ln -sf ~/.pEnv/assets/$rc ~/.$rc
done

echo "Installation complete!"
