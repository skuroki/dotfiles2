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

# Install GitHub CLI first
brew install gh

# Generate SSH key pair if not exists
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "Setting up SSH key for GitHub..."
    
    # GitHub CLI authentication using browser (already logged in)
    echo "Authenticating with GitHub CLI using browser..."
    gh auth login --web --scopes write:public_key
    
    # Get GitHub email from authenticated user
    github_email=$(gh api user/emails --jq '.[] | select(.primary==true) | .email')
    echo "Using GitHub email: $github_email"
    
    ssh-keygen -t ed25519 -C "$github_email" -f ~/.ssh/id_ed25519 -N ""
    
    # Start ssh-agent and add key
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    
    # Add SSH key to GitHub account
    gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname)-$(date +%Y%m%d)"
    
    echo "SSH key successfully added to GitHub!"
fi

# Test SSH connection
ssh -T git@github.com || echo "SSH connection verified"

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
