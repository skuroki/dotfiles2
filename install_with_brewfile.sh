#!/usr/bin/env bash -xe

# Brewfile setup script
# This replaces the Ansible-based package installation

cd $HOME
rm -rf dotfiles2

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Install Xcode command line tools
xcode-select --install || true

# Setup Homebrew environment
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/shinsukekuroki/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Update Homebrew
brew update

# Clone the repository
git clone git@github.com:skuroki/dotfiles2.git

# Install packages using Brewfile
cd dotfiles2
brew bundle

# Setup environment variables
echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"' >> ~/.bash_profile
source ~/.bash_profile

# Install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
fi

# Setup dotfiles (legacy)
cd $HOME
rm -rf dotfiles
git clone git@github.com:skuroki/dotfiles.git
cd dotfiles
bash -x ./install.sh
