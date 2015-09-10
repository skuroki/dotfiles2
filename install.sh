#!/usr/bin/env bash

cd $HOME
rm -rf dotfiles2

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update

brew install python
brew install ansible
brew install git

git clone https://github.com/skuroki/dotfiles2.git

echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"' >> ~/.bash_profile
source ~/.bash_profile

cd dotfiles2/provisioning
ansible-playbook -i hosts -vv localhost.yml
