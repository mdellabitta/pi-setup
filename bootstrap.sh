#!/usr/bin/bash

# The purpose of this script is to get the box set up for running the
# ansible playbooks in the repo. We're installing the latest ansible
# using pip, and pip and a recent python using pyenv.

# Script is written assuming Raspbian. May work elsewhere. In the case
# of the Vagrantfile in this repo, it's working in Debian x86-64. 

set -euxo pipefail

echo '---> Updating package list'
sudo apt-get update

# Most of these dependencies are here to get python builds working.
echo '---> Installing packages'
sudo apt-get install -y \
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

if ! [[ -d $HOME/pi-setup ]]
then
	echo '---> Cloning pi-setup'
	git clone https://github.com/mdellabitta/pi-setup.git
fi

if ! [[ -d $HOME/.pyenv ]]
then
	echo '---> Downloading and building pyenv'
	git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
	cd $HOME/.pyenv && src/configure && make -C src; cd -
fi

if ! grep -q pyenv $HOME/.profile
then
	echo '---> Installing pyenv into .profile'
	echo 'export PYENV_ROOT="$HOME/.pyenv"' > $HOME/profile.tmp
	echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/profile.tmp
	echo 'eval "$(pyenv init --path)"' >> $HOME/profile.tmp
	cat $HOME/.profile >> $HOME/profile.tmp
	mv $HOME/.profile $HOME/.profile.bak.$(timestamp=$(date +%s))
	mv $HOME/profile.tmp $HOME/.profile
fi

source $HOME/.profile

echo '---> Installing python 3.10.2 and setting it as default'
pyenv install -s 3.10.2
pyenv global 3.10.2


echo '---> Upgrading pip'
pip install --upgrade pip


echo '---> Installing Python wheel and setuptools'
pip install --upgrade wheel setuptools


echo '---> Installing ansible and requirements'
pip install --upgrade ansible

cd $HOME/pi-setup && ansible-galaxy collection install -r=ansible/requirements.yml; cd -
