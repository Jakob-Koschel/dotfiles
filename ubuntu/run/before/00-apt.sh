#!/usr/bin/env bash

set -e

sudo apt-get update
sudo apt-get install -y \
	wget \
	zsh \
	vim \
	git \
	curl \
	tmux \
	time \
	build-essential \
	sudo
