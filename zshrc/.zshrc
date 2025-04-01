# Alias VI and VIM to NVIM
alias vim="nvim"
alias vi="nvim"
alias oldvim="/usr/bin/vim"
# Allow vim bindings to zsh shell
bindkey -v
# Enable fzf open with neovim
alias f='file=$(fzf); [ -n "$file" ] && cd "$(dirname "$file")" && vim "$(basename "$file")"'
