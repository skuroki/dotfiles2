#!/usr/bin/env bash -xe

cd $HOME
rm -rf dotfiles2

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
xcode-select --install

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/shinsukekuroki/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update

brew install python || brew upgrade python
brew install ansible || brew upgrade ansible
brew install git || brew upgrade git

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

# VS Code設定とエクスションのセットアップ
echo "🔧 VS Codeの設定を適用しています..."
cd $HOME/dotfiles2/vscode
./setup_vscode.sh
