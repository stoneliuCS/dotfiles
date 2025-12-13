#!/bin/bash

# Installs all LSPs required

brew install lua-language-server
brew install texlab
brew install gopls
brew install tinymist

npm install -g basedpyright --force
npm install -g pyright --force
npm install -g @vtsls/language-server --force
npm install -g yaml-language-server --force

rustup component add rust-analyzer
cargo install typstyle --locked

go install github.com/a-h/templ/cmd/templ@latest
