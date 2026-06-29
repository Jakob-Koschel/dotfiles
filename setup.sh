#!/usr/bin/env bash

set -euo pipefail

DRY_RUN=0
case "${1:-}" in
  --dry-run) DRY_RUN=1 ;;
  "") ;;
  *) echo "unknown argument: $1" >&2; exit 1 ;;
esac

cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd -P)
BASHDOT="$DOTFILES_ROOT/bashdot/bashdot"
PROFILES_ROOT="$DOTFILES_ROOT/profiles"
UNAME=$(uname -s)

SESSION_TYPE=""
if [[ -n "${SSH_CLIENT:-}" || -n "${SSH_TTY:-}" ]]; then
  SESSION_TYPE=remote/ssh
fi

PROFILES=()
case "$UNAME" in
  Darwin)
    PROFILES+=(macos)
    ;;
  Linux*)
    if [ ! -r /etc/os-release ]; then
      echo "cannot detect Linux distribution: /etc/os-release not found" >&2
      exit 1
    fi
    # shellcheck disable=SC1091
    . /etc/os-release
    case "${ID:-linux}" in
      ubuntu|debian)
        PROFILES+=(linux/ubuntu linux/base)
        if [[ "$SESSION_TYPE" != "remote/ssh" ]]; then
          PROFILES+=(linux/ubuntu-desktop)
        fi
        ;;
      *)
        echo "unsupported Linux distribution: ${PRETTY_NAME:-${ID:-unknown}}" >&2
        exit 1
        ;;
    esac
    if [[ "$SESSION_TYPE" != "remote/ssh" ]]; then
      PROFILES+=(linux/desktop)
    fi
    ;;
  *)
    echo "unsupported OS: $UNAME" >&2
    exit 1
    ;;
esac
PROFILES+=(common)

if [[ "$DRY_RUN" == 1 ]]; then
  printf '%s\n' "${PROFILES[@]}"
  exit 0
fi

if [ ! -x "$BASHDOT" ]; then
  echo "bashdot not found or not executable at $BASHDOT" >&2
  exit 1
fi

# stow is required by bashdot; install on apt-based systems if missing
if [[ "$UNAME" == Linux* ]] && ! command -v stow &>/dev/null; then
  sudo apt update && sudo apt install -y stow
fi

git submodule update --init --recursive

# /opt/homebrew/bin is Apple Silicon brew prefix; /usr/local/bin covers Intel brew + system local
if [[ "$UNAME" == "Darwin" ]]; then
  export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
fi

# adopt pre-existing target files into the repo instead of failing on conflict;
# reconcile afterwards with 'git restore profiles' to keep the repo's versions.
# On by default; override with BASHDOT_ADOPT=0 ./setup.sh to disable.
export BASHDOT_ADOPT="${BASHDOT_ADOPT:-1}"

for phase in before install after; do
  echo ">>> bashdot $phase ${PROFILES[*]}"
  (cd "$PROFILES_ROOT" && "$BASHDOT" "$phase" "${PROFILES[@]}")
done
