#!/usr/bin/env bash

set -e

# fixes issues with cocoapods by forcing usage of the brew version
export PATH="$(brew --prefix)/opt/ruby/bin:$PATH"
export LDFLAGS="-L$(brew --prefix)/opt/ruby/lib"
export CPPFLAGS="-I$(brew --prefix)/opt/ruby/include"

gem install ffi

# install cocoapods
gem install cocoapods
