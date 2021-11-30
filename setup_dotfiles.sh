#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

VUNDLE_GIT_REMOTE="https://github.com/VundleVim/Vundle.vim.git"
OHMYZSH_GIT_REMOTE="https://github.com/robbyrussell/oh-my-zsh.git"
TPM_GIT_REMOTE="https://github.com/tmux-plugins/tpm.git"
DRACULA_ZSH_GIT_REMOTE="https://github.com/dracula/zsh.git"

# Generates colored output.
function special_echo {
  echo -e '\E[0;32m'"$1\033[0m"
}

if [ "$(uname)" == "Darwin" ]; then
  OS_NAME="MacOS"
  $DIR/osx/setup.sh
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  OS_NAME="Linux"
  $DIR/linux/setup.sh
fi

special_echo "Setup Vundle"
test -d $DIR/_vim/bundle/Vundle.vim || git clone $VUNDLE_GIT_REMOTE $DIR/_vim/bundle/Vundle.vim

special_echo "Setting $HOME/.vim to link to $DIR/_vim directory"
rm -rf $HOME/.vim
ln -sfn $DIR/_vim $HOME/.vim

special_echo "Overwriting $HOME/.vimrc"
ln -sfn $DIR/_vimrc $HOME/.vimrc

special_echo "Install Vundle plugins"
vim +BundleInstall +qall

special_echo "Setup Oh My Zsh"
test -d $DIR/_oh_my_zsh || git clone $OHMYZSH_GIT_REMOTE $DIR/_oh_my_zsh

# special_echo "Setup Dracula theme"
# git clone $DRACULA_ZSH_GIT_REMOTE $DIR/_dracula
# ln -s $DIR/_dracula/dracula.zsh-theme $DIR/_oh_my_zsh/themes/dracula.zsh-theme

special_echo "Setup $HOME/.oh-my-zsh"
ln -sfn $DIR/_oh_my_zsh $HOME/.oh-my-zsh

special_echo "Setting $HOME/.zsh"
mkdir -p $HOME/.zsh

# special_echo "Setting $HOME/.zsh/path.zsh"
# if [ "$OS_NAME" == "MacOS" ]; then
#   ggrep GITCRYPT $DIR/_gitconfig || ln -sfn $DIR/zsh/_path.zsh_mac $HOME/.zsh/path.zsh
#   if ggrep GITCRYPT $DIR/_gitconfig
#   then
#     touch $HOME/.zsh/path.zsh
#   else
#     ln -sfn $DIR/zsh/_path.zsh_mac $HOME/.zsh/path.zsh
#   fi
# elif [ "$OS_NAME" == "Linux" ]; then
#   grep GITCRYPT $DIR/_gitconfig || ln -sfn $DIR/zsh/_path.zsh_linux $HOME/.zsh/path.zsh
#   if grep GITCRYPT $DIR/_gitconfig
#   then
#     touch $HOME/.zsh/path.zsh
#   else
#     ln -sfn $DIR/zsh/_path.zsh_linux $HOME/.zsh/path.zsh
#   fi
# fi

special_echo "Overwriting $HOME/.zshrc"
ln -sfn $DIR/_zshrc $HOME/.zshrc

special_echo "Overwriting $HOME/.tmux.conf.common"
ln -sfn $DIR/_tmux.conf.common $HOME/.tmux.conf.common
special_echo "Overwriting $HOME/.tmux.conf"
if [ "$OS_NAME" == "MacOS" ]; then
  ln -sfn $DIR/_tmux.conf_mac $HOME/.tmux.conf
elif [ "$OS_NAME" == "Linux" ]; then
  ln -sfn $DIR/_tmux.conf_linux $HOME/.tmux.conf
fi

special_echo "Setup TPM"
test -d $DIR/_tmux/plugins/tpm || git clone $TPM_GIT_REMOTE $DIR/_tmux/plugins/tpm

special_echo "Setting $HOME/.tmux"
ln -sfn $DIR/_tmux $HOME/.tmux

special_echo "Install TPM plugins"
$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh

# special_echo "Overwriting $HOME/.gitconfig"
# if [ "$OS_NAME" == "MacOS" ]; then
#   ggrep GITCRYPT $DIR/_gitconfig || ln -sfn $DIR/_gitconfig $HOME/.gitconfig
# elif [ "$OS_NAME" == "Linux" ]; then
#   grep GITCRYPT $DIR/_gitconfig || ln -sfn $DIR/_gitconfig $HOME/.gitconfig
# fi
