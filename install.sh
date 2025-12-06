#!/bin/bash

brew install --cask mactex
brew install neovim
brew install tmux
brew install fzf
brew install stow
brew install luarocks
brew install pandoc
brew install --cask skim
brew install go
brew install imagemagick

# Updates all existing packages and ensures you have all managers installed.
brew update
brew upgrade
brew cleanup
npm update -g
rustup update

stow nvim 
stow git 
stow nix
stow tmux
stow zshrc 

# Install Tmux Plugin Manager in the root directory
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf
