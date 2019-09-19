#!/bin/bash

# cp .bashrc .emacs .tmux.conf .inputrc .myshell.sh $HOME
# make symbolic links for all dot files

dotfiles=( .bashrc .emacs .inputrc .myshell.sh .zshrc )

for i in "${dotfiles[@]}"
do
    ln -s -f $HOME/$i ./$i
done

ln -s -f $HOME/.tmux.conf ./.tmux/.tmux.conf

