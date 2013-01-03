#!/bin/sh


HERE=`dirname $0`
cp $HERE/.screenrc ~
cp $HERE/.tmux.conf ~
cp $HERE/.zshrc ~
cp -R $HERE/.vim ~
cp $HERE/.vimrc ~
cp $HERE/.mongorc.js ~
#install oh my zsh
curl -L https://github.com/mpobrien/oh-my-zsh/raw/master/tools/install.sh | sh


