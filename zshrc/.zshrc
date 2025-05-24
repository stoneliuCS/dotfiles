# Alias VI and VIM to NVIM
alias vim="nvim"
alias vi="nvim"
alias oldvim="/usr/bin/vim"
# Allow vim bindings to zsh shell
bindkey -v
export PATH="$HOME/.bun/bin:$PATH"
# Limit fzf to only one file deep for performance
alias f='nvim $(fzf)'
