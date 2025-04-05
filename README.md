# Dotfiles

## Getting Started:

Clone the repository

```bash
git clone https://github.com/stoneliuCS/dotfiles.git ~/dotfiles
```

## Dependencies:
```bash
# Brew Installation
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Nix Installation
sh <(curl -L https://nixos.org/nix/install)
# Install MacTex (For Latex Editing)
brew install --cask mactex
# Install Neovim 
brew install neovim
# Install tmux 
brew install tmux
# Install fzf
brew install fzf
# Install GNU Stow
brew install stow
# Install luarocks
brew install luarocks
# Install Tmux Plugin Manager in the root directory
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Add symlinks to local machine:
```bash 
# In dotfiles root directory
stow nvim 
stow git 
stow nix
stow tmux
stow zshrc 
```

Source the tmux file
```bash 
tmux source ~/.tmux.conf
```
