#!/bin/sh

set -x

sudo apt install -y ansible
sudo ansible-galaxy collection install community.general
