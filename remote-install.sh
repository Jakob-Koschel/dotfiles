#!/usr/bin/env bash

set -e

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if [ $# -lt 1 ]; then
  echo "please run like this './remote-install.sh <hostname>'"
  exit 1
fi

remote_command() {
  if [ $# -lt 2 ]; then
    echo "please call remote_command like this: 'remote_command <hostname> <command>'"
  fi

  HOSTNAME=$1
  COMMAND=$2

  ssh $HOSTNAME -t "$COMMAND"
}

HOSTNAME=$1

remote_command $HOSTNAME 'mkdir -p ~/Developer'
remote_command $HOSTNAME 'ls ~/Developer/dotfiles/remote-install.sh' && DOTFILES_EXIST=1 || true
if [ -z "$DOTFILES_EXIST" ]; then
  remote_command $HOSTNAME 'cd Developer && bash <(curl -L -s https://raw.githubusercontent.com/Jakob-Koschel/dotfiles/master/github-install.sh)'
else
  remote_command $HOSTNAME 'cd Developer/dotfiles && git pull'
  remote_command $HOSTNAME 'bash -c "cd Developer/dotfiles && ./setup.sh"'
fi

# offer to replace the remote's HTTPS clone URL with SSH for future pulls
remote_command $HOSTNAME "$(cat <<'EOF'
cd Developer/dotfiles
GIT_REMOTE_URL=$(git remote get-url origin)
if [[ $GIT_REMOTE_URL == https* ]]; then
  read -p "Repository is cloned via HTTPS. Should this be replaced with SSH? [yN]: " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    REPO=$(echo $GIT_REMOTE_URL | sed -n 's@^.*github.com/*/\([^)]*\).*$@\1@p')
    USERNAME=${REPO%/*}
    REPOSITORY=${REPO#*/}
    git remote set-url origin "git@github.com:$USERNAME/$REPOSITORY"
  fi
fi
EOF
)"
