# Alias VI and VIM to NVIM
alias v2=nvim
alias vim=nvim
alias vi=nvim
alias oldvim="/usr/bin/vim"
# Allow vim bindings to zsh shell
bindkey -v
export PATH="$HOME/.bun/bin:$PATH"
source <(fzf --zsh)
alias f='vim $(fzf --style default --preview "fzf-preview.sh {}" --bind "focus:transform-header:file --brief {}")'

# bun completions
[ -s "/Users/stoneliu/.bun/_bun" ] && source "/Users/stoneliu/.bun/_bun"

# Add fcd for faster finding of directories
fcd() {
    local dir
    dir=$(fd -t d 2>/dev/null |
      fzf --preview="ls -la {}" --bind "tab:down,btab:up")
    cd "$dir"
}

cheat() { clear && curl cheat.sh/"$1" ; }

# Add Go to ZSHRC
export GOBIN=$(go env GOPATH)/bin
export PATH=$GOBIN:$PATH

# Euporie Notebook ALIAS
alias ep='MPLBACKEND=Agg euporie-notebook --log-level=debug --log-file=euporie.log --graphics sixel'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.4.1 # run chruby to see actual version

# pnpm
export PNPM_HOME="/Users/stone/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="$HOME/.local/bin:$PATH"

eval "$(mise activate zsh)"

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# Add alias and function to print out my todo list.
todo_read() {
  local repo
  repo="$(fd -t d -d 6 '^wiki$' "$HOME" | head -n1)"
  [ -z "$repo" ] && { echo "wiki repo not found"; return 1; }
  awk '
    $0 == "= Hall of ToDo'\''s Version 2" {flag=1; next}
    $0 == "= Hall of Finished ToDo'\''s Version 2" {exit}
    flag
  ' "$repo/content/todo.typ"
}

alias todo='todo_read'

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
