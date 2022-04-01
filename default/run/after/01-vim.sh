#!/usr/bin/env bash

set -e

VUNDLE_GIT_REMOTE="https://github.com/VundleVim/Vundle.vim.git"

if [ ! -e $HOME/.vim/bundle/Vundle.vim ]; then
  git clone $VUNDLE_GIT_REMOTE $HOME/.vim/bundle/Vundle.vim
fi

vim +BundleInstall +qall

if [ ! -e $HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core*.so ]; then
  cd $HOME/.vim/bundle/YouCompleteMe && ./install.py --clangd-completer
fi
