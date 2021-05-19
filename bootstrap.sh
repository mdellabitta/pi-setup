#!/usr/bin/bash

# The purpose of this script is to get the box set up for running the
# ansible playbooks in the repo. We're installing the latest ansible
# using pip, and pip and a recent python using pyenv.

# Script is written assuming Debian Buster. May work elsewhere.

set -euxo pipefail

sudo apt update

# Most of these dependencies are here to get python builds working.

sudo apt install -y \
	git \
	make \
	build-essential \
	libssl-dev \
	zlib1g-dev \
	libbz2-dev \
	libreadline-dev \
	libsqlite3-dev \
	wget \
	curl \
	llvm \
	libncursesw5-dev \
	xz-utils \
	tk-dev \
	libxml2-dev \
	libxmlsec1-dev \
	libffi-dev \
	liblzma-dev \
	rustc

if ! [[ -d ~/pi-setup ]]
then
	git clone https://github.com/mdellabitta/pi-setup.git
fi

if ! [[ -d ~/.pyenv ]]
then
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	cd ~/.pyenv && src/configure && make -C src; cd ~
fi

if [ $(grep -q pyenv ~/.profile) ]
then
	echo 'Installing pyenv into .profile'
	echo 'export PYENV_ROOT="$HOME/.pyenv"' > profile.tmp
	echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> profile.tmp
	echo 'eval "$(pyenv init --path)"' >> profile.tmp
	cat .profile >> profile.tmp
	mv .profile .profile.bak.$(timestamp=$(date +%s))
	mv profile.tmp .profile
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init --path)"
fi

pyenv install -s 3.9.5
cd ~/pi-setup/ansible
pyenv local 3.9.5
python -m venv venv
pip install ansible
ansible-galaxy collection install community.general
cd ~
