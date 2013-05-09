#!/bin/bash
PACKAGES="vim tmux zsh git"

read -p "Attempt install of helpful packages? [yn] " ynInstall
if [ "$ynInstall" == "y" ]; then
  if command -v aptitude > /dev/null; then
    sudo aptitude install $PACKAGES
  elif command -v yum > /dev/null; then
    sudo yum install $PACKAGES
  fi
fi

git clone https://github.com/nomcopter/pEnv.git ~/.pEnv

exec ~/.pEnv/install.sh
