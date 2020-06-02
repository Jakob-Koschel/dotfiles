#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

$DIR/osxprep.sh
$DIR/brew.sh
$DIR/osx.sh

cp $DIR/karabiner.json ~/.config/karabiner/
