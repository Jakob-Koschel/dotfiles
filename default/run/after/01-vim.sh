#!/usr/bin/env bash

set -e

VUNDLE_GIT_REMOTE="https://github.com/VundleVim/Vundle.vim.git"

if [ ! -e $HOME/.vim/bundle/Vundle.vim ]; then
  git clone $VUNDLE_GIT_REMOTE $HOME/.vim/bundle/Vundle.vim
fi

vim +BundleInstall +qall
