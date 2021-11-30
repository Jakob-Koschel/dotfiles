# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(
  git
  macos
  tmux
  react-native
  history
  z
  gitfast
)

source $ZSH/oh-my-zsh.sh

autoload -U compinit && compinit
zmodload -i zsh/complist

bindkey '^R' history-incremental-search-backward
bindkey "^P" up-line-or-search

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export SED=gsed

source $HOME/.zsh/path.zsh

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

alias rssh='rsync --progress -avz -e "ssh"'

# functions to convert between bases
function hex2dec() {
  python3 -c "print(int('$1', 16))"
}

function hex2bin() {
  python3 -c "print(bin(int('$1', 16)))"
}

function bin2hex() {
  python3 -c "print(hex(int('$1', 2)))"
}

function bin2dec() {
  python3 -c "print(int('$1', 2))"
}

function dec2hex() {
  python3 -c "print(hex($1))"
}

function dec2bin() {
  python3 -c "print(bin($1))"
}
