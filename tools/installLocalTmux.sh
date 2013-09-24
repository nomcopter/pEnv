#!/bin/bash
 
# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $HOME/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.
 
# exit on error
set -e
 
# create our directories
mkdir -p $HOME/local $HOME/tmux_tmp
cd $HOME/tmux_tmp
 
# download source files for tmux, libevent, and ncurses
wget -O tmux.tar.gz http://downloads.sourceforge.net/project/tmux/tmux/tmux-1.8/tmux-1.8.tar.gz
wget -O libevent.tar.gz https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
wget -O ncurses.tar.gz ftp://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz
 
# extract files, configure, and compile
 
############
# libevent #
############
tar xvzf libevent.tar.gz
cd libevent*
./configure --prefix=$HOME/local --disable-shared
make
make install
cd ..
 
############
# ncurses #
############
tar xvzf ncurses.tar.gz
cd ncurses*
./configure --prefix=$HOME/local
make
make install
cd ..
 
############
# tmux #
############
tar xvzf tmux.tar.gz
cd tmux*
./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include"
CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" make
cp tmux $HOME/local/bin
cd ..
 
# cleanup
rm -rf $HOME/tmux_tmp
