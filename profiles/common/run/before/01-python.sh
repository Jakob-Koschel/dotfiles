#!/usr/bin/env bash

set -e

# virtualenv stuff is essential; it must be provided by the system package
# manager (Homebrew on macOS, apt on Linux).
if ! command -v virtualenv &> /dev/null; then
  echo "error: virtualenv not found; install it via your package manager" >&2
  exit 1
fi

# Locate virtualenvwrapper.sh wherever it was installed (Homebrew, distro, ...).
wrapper_sh="$(command -v virtualenvwrapper.sh || true)"
if [ -z "$wrapper_sh" ]; then
  for candidate in \
    /opt/homebrew/bin/virtualenvwrapper.sh \
    /usr/local/bin/virtualenvwrapper.sh \
    "$(python3 -m site --user-base)/bin/virtualenvwrapper.sh" \
    /usr/share/virtualenvwrapper/virtualenvwrapper.sh; do
    if [ -f "$candidate" ]; then
      wrapper_sh="$candidate"
      break
    fi
  done
fi

if [ -z "$wrapper_sh" ]; then
  echo "error: virtualenvwrapper not found; install it via your package manager" >&2
  exit 1
fi
# shellcheck disable=SC1090
source "$wrapper_sh"
