#!/bin/sh
set -e

echo "\033[0;34mCloning dotfiles...\033[0m"
git clone https://github.com/mpobrien/dotfiles.git ~/.dotfiles
DOT_ROOT=~/.dotfiles
cp $DOT_ROOT/.screenrc ~
cp $DOT_ROOT/.tmux.conf ~
cp $DOT_ROOT/.zshrc ~
cp -R $DOT_ROOT/.vim ~
cp $DOT_ROOT/.vimrc ~
cp $DOT_ROOT/.mongorc.js ~
#install oh my zsh
curl -L https://github.com/mpobrien/oh-my-zsh/raw/master/tools/install.sh | sh
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
