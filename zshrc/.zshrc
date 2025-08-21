# Alias VI and VIM to NVIM
alias v='NVIM_APPNAME="nvim2" nvim'
alias vim="nvim"
alias vi="nvim"
alias oldvim="/usr/bin/vim"
# Allow vim bindings to zsh shell
bindkey -v
export PATH="$HOME/.bun/bin:$PATH"
# Limit fzf to only one file deep for performance
alias f='nvim $(fzf)'

# bun completions
[ -s "/Users/stoneliu/.bun/_bun" ] && source "/Users/stoneliu/.bun/_bun"

# Add fcd for faster finding of directories
fcd() {
    local dir
    dir=$(find . -type d 2>/dev/null | fzf --preview="ls -la {}") && cd "$dir"
}

# Add Go to ZSHRC
export GOBIN=$(go env GOPATH)/bin
export PATH=$GOBIN:$PATH
