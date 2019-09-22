#!/bin/bash

# cp .bashrc .emacs .tmux.conf .inputrc .myshell.sh $HOME
# make symbolic links for all dot files

dotfiles=( .bashrc .emacs .inputrc .myshell.sh .zshrc )
currpath=`pwd`
#echo $currpath

for i in "${dotfiles[@]}"
do
    ln -s -f $currpath/$i $HOME
done

ln -s -f $currpath/.tmux $HOME
ln -s -f $currpath/.oh-my-zsh $HOME
ln -s -f $currpath/.tmux/.tmux.conf $HOME
