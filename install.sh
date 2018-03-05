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

mkdir -p ~/local/bin
git submodule init
git submodule update

case $OSTYPE in 
  darwin*)
    echo

    if ! [ -x "$(command -v brew)" ]; then
      echo "Installing Homebrew..."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "Brewing packages..."
    brew install git tmux coreutils the_silver_searcher fzf vim reattach-to-user-namespace
    if [ ! -f ~/.fzf.zsh ]; then
      $(brew --prefix)/opt/fzf/install --key-bindings --completion
    fi

    echo "Linking utils..."
    backup-and-link /usr/local/bin/gdircolors ~/local/bin/dircolors
    backup-and-link /usr/local/bin/gls ~/local/bin/ls

    # TODO: Setup fonts
    # TODO: Install/Setup iTerm2
    ;;
  linux*)
    echo
    echo "Setting up fonts..."
    backup-and-link ~/.pEnv/assets/fonts ~/.fonts
    fc-cache -vf ~/.fonts
    mkdir -p ~/.config/fontconfig/conf.d/
    backup-and-link ~/.pEnv/assets/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/10-powerline-symbols.conf

    echo
    echo "Setting up ROXTerm..."
    backup-and-link ~/.pEnv/assets/roxterm  ~/.config/roxterm.sourceforge.net
    ;;
esac

echo
echo "Setting up git-number..."
backup-and-link ~/.pEnv/assets/git-number/git-number  ~/local/bin/git-number
backup-and-link ~/.pEnv/assets/git-number/git-list    ~/local/bin/git-list
backup-and-link ~/.pEnv/assets/git-number/git-id      ~/local/bin/git-id

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
echo "Installation complete!"
