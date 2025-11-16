#!/bin/bash

# Updates all existing packages
brew update
brew upgrade
brew cleanup

npm update -g

# INSTALLING PACKAGES
brew install --cask mactex
brew install neovim
brew install tmux
brew install fzf
brew install stow
brew install luarocks
brew install pandoc
brew install --cask skim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
