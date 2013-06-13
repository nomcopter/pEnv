#!/bin/bash
echo "Updating pEnv.."
cd ~/.pEnv
git pull

exec ~/.pEnv/install.sh
