#!/bin/sh


HERE=`dirname $0`
cp $HERE/.screenrc ~
cp $HERE/.tmux.conf ~
cp $HERE/.zshrc ~
cp -R $HERE/.vim ~
cp $HERE/.vimrc ~
cp $HERE/.mongorc.js ~
