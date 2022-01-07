#!/usr/bin/env bash

set -e

# fixes issues with cocoapods by forcing usage of the brew version
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

gem install ffi

# install cocoapods
gem install cocoapods
