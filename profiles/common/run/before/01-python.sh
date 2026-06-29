#!/usr/bin/env bash

set -e

# virtualenv stuff is essential
if ! command -v virtualenv &> /dev/null; then
  pip3 install --user virtualenv
fi
if ! command -v virtualenvwrapper.sh &> /dev/null; then
  pip3 install --user virtualenvwrapper
fi

# Locate virtualenvwrapper.sh wherever it was installed (Homebrew, pip --user, distro).
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

if [ -n "$wrapper_sh" ]; then
  source "$wrapper_sh"
else
  echo "warning: virtualenvwrapper.sh not found; skipping source" >&2
fi

# pynvim for neovim support
if ! pip3 show pynvim >/dev/null; then
  pip3 install --user --break-system-packages pynvim
fi

if ! pip3 show python-dotenv >/dev/null; then
  pip3 install --user --break-system-packages python-dotenv
fi
