#!/bin/sh

echo "\033[0;34mCloning dotfiles...\033[0m"

DOT_ROOT=~/.dotfiles
cp $DOT_ROOT/.screenrc ~
cp $DOT_ROOT/.tmux.conf ~
cp $DOT_ROOT/.zshrc ~
cp -R $DOT_ROOT/.vim ~
cp $DOT_ROOT/.vimrc ~
cp $DOT_ROOT/.mongorc.js ~
#install oh my zsh
curl -L https://github.com/mpobrien/oh-my-zsh/raw/master/tools/install.sh | sh


cp $DOT_ROOT/.zshrc ~
