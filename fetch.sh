#!/bin/bash
(command -v vim > /dev/null && command -v git > /dev/null) || { echo "ERROR: Both vim and git must be installed to continue"; exit 1; }

read -p "Have you installed your ssh key into github? [yN] " ynInstall
[ "$ynInstall" == "y" ] && url="git@github.com:nomcopter/pEnv.git" || url="https://github.com/nomcopter/pEnv.git"

git clone $url ~/.pEnv

exec ~/.pEnv/install.sh
