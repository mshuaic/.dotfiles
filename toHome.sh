#!/bin/bash

currpath=$(dirname $(readlink -nf -- "$0"))
git submodule update --init --recursive --remote

# apply custom configuration to .tmux.conf.local
cp $currpath/.tmux/.tmux.conf.local $currpath
cat $currpath/.tmux.conf.local.diff >> $currpath/.tmux.conf.local


# cp .bashrc .emacs .tmux.conf .inputrc .myshell.sh $HOME
# make symbolic links for all dot files

dotfiles=( .emacs .inputrc .myshell.sh .zshrc .tmux.conf.local)

#echo $currpath

for i in "${dotfiles[@]}"
do
    ln -s -f $currpath/$i $HOME
done

ln -s -f $currpath/.tmux $HOME
ln -s -f $currpath/.tmux/.tmux.conf $HOME
ln -s -f $currpath/.oh-my-zsh $HOME

$SHELL .myshell.sh
