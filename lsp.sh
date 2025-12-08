#!/bin/bash

# Installs all LSPs required

brew install lua-language-server
brew install texlab
npm install -g basedpyright --force
npm install -g pyright --force
npm install -g @vtsls/language-server --force
npm install -g yaml-language-server --force
brew install gopls
rustup component add rust-analyzer
brew install tinymist
