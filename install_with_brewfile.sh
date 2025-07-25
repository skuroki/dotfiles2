#!/usr/bin/env bash -xe

# Brewfile setup script
# This replaces the Ansible-based package installation

# Request sudo access upfront
echo "This script requires sudo access for system configuration."
echo "Please enter your password to continue:"
sudo -v

# Keep sudo alive in the background
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

cd $HOME
rm -rf dotfiles2

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh > /tmp/homebrew_install.sh
    /bin/bash /tmp/homebrew_install.sh
    rm /tmp/homebrew_install.sh
    echo "Homebrew installation completed."
fi

# Install Xcode command line tools
if ! xcode-select -p &> /dev/null; then
    xcode-select --install
    echo "Xcode command line tools installation started. Please wait for it to complete."
    # Wait for installation to complete
    until xcode-select -p &> /dev/null; do
        sleep 30
        echo "Waiting for Xcode command line tools installation to complete..."
    done
fi

# Install Rosetta 2 if on Apple Silicon Mac
if [[ $(uname -m) == "arm64" ]]; then
    echo "Installing Rosetta 2 for Apple Silicon Mac..."
    sudo softwareupdate --install-rosetta --agree-to-license
    echo "Rosetta 2 installation completed."
fi

# Setup Homebrew environment
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Update Homebrew
brew update

# Install GitHub CLI first
brew install gh

# Generate SSH key pair if not exists
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "Setting up SSH key for GitHub..."
    
    # GitHub CLI authentication using browser
    echo "Authenticating with GitHub CLI using browser..."
    gh auth login --web --scopes write:public_key,user:email
    
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

# Clone the repository
git clone git@github.com:skuroki/dotfiles2.git

# Install packages using Brewfile
cd dotfiles2
brew bundle

# Setup environment variables
echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"' >> ~/.bash_profile
source ~/.bash_profile

# Configure CapsLock key to Control key
echo "Setting up CapsLock to Control key mapping..."
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}'

# Create LaunchAgent for persistent key mapping
sudo mkdir -p /Library/LaunchDaemons
sudo tee /Library/LaunchDaemons/com.local.KeyRemapping.plist > /dev/null << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.KeyRemapping</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Load the LaunchAgent
sudo launchctl load /Library/LaunchDaemons/com.local.KeyRemapping.plist

echo "CapsLock key has been mapped to Control key!"

# Configure Google Japanese IME as default input source
echo "Setting up Google Japanese IME as default input source..."

# Wait for Google Japanese IME to be fully installed
sleep 5

# Enable Google Japanese IME in input sources
defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '{
    "Bundle ID" = "com.google.inputmethod.Japanese";
    "InputSourceKind" = "Keyboard Input Method";
    "KeyboardLayout Name" = "com.google.inputmethod.Japanese";
}'

# Set Google Japanese IME as the current input source
defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID "com.google.inputmethod.Japanese"

# Clear preferences cache
killall cfprefsd 2>/dev/null

echo "Google Japanese IME has been configured as the default input source."
echo "Please log out and log back in to apply the input source changes."

# VS Code設定とエクスションのセットアップ
echo "🔧 VS Codeの設定を適用しています..."
cd $HOME/dotfiles2/vscode
./setup_vscode.sh

# Setup dotfiles (legacy)
cd $HOME
rm -rf dotfiles
git clone git@github.com:skuroki/dotfiles.git
cd dotfiles
bash -xe ./install.sh
