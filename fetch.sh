#!/bin/bash
PACKAGES="vim tmux zsh git"

read -p "Attempt install of helpful packages? [yn] " ynInstall
if [ "$ynInstall" == "y" ]; then
  if command -v apt-get > /dev/null; then
    sudo apt-get install $PACKAGES
  elif command -v yum > /dev/null; then
    sudo yum install $PACKAGES
  elif command -v brew > /dev/null; then
    brew install $PACKAGES
  fi
fi

read -p "Have you installed your ssh key into github? [yn] " ynInstall
[ "$ynInstall" == "y" ] && url="git@github.com:nomcopter/pEnv.git" || url="https://github.com/nomcopter/pEnv.git"

git clone $url ~/.pEnv

exec ~/.pEnv/install.sh
