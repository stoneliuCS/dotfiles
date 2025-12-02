#!/bin/bash

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
# Install pandoc
brew install pandoc
# Install Skim the better pdf viewer
brew install --cask skim
brew install go
# Install Tmux Plugin Manager in the root directory
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Updates all existing packages
brew update
brew upgrade
brew cleanup

npm update -g

stow nvim 
stow git 
stow nix
stow tmux
stow zshrc 

tmux source ~/.tmux.conf
