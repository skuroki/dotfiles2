#!/usr/bin/env bash -xe

cd $HOME
rm -rf dotfiles2

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update

brew install python
brew install ansible
brew install git

git clone git@github.com:skuroki/dotfiles2.git

echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"' >> ~/.bash_profile
source ~/.bash_profile

cd dotfiles2/provisioning
ansible-playbook -i hosts -vv localhost.yml -K

cd $HOME
rm -rf dotfiles
git clone git@github.com:skuroki/dotfiles.git
cd dotfiles
bash -x ./install.sh
