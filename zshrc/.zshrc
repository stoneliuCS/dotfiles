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
  local repo="$HOME/stone-zone/wiki"
  awk '
    $0 == "= Todos:" {flag=1}
    flag && /^_/ {print; exit}
    flag
  ' "$repo/content/todo.typ"
}

alias todo='todo_read'

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

cpprun() {
    g++ -x c++ -std=c++17 -O2 -Wall -Wextra -g "$1" -o /tmp/cpprun_out && /tmp/cpprun_out
}

javarun() {
    java --source 17 "$1" "${@:2}"
}


# Docker cleanup helpers
remove_all_docker_containers_and_volumes() {
    docker rm -vf $(docker ps -aq)
}

remove_all_docker_images() {
    echo "Removing all docker images."
    docker rmi -f $(docker images -aq)
}

nuke() {
    docker system prune -a --volumes -f
}

# Retry an rsync transfer until it succeeds
rsync_retry() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: rsync_retry <source> <destination> [delay_seconds]" >&2
        return 2
    fi

    local source_path=$1
    local destination_path=$2
    local delay_seconds=${3:-10}
    local attempt=1

    while true; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] attempt ${attempt}: syncing ${source_path} -> ${destination_path}"

        rsync -avP --partial --append-verify \
            -e "ssh -o ServerAliveInterval=30 -o ServerAliveCountMax=6" \
            "$source_path" "$destination_path"
        local exit_code=$?

        if [ "$exit_code" -eq 0 ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] sync completed successfully"
            return 0
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] rsync exited with code ${exit_code}; retrying in ${delay_seconds}s"
        attempt=$((attempt + 1))
        sleep "$delay_seconds"
    done
}

# Convert a PDF page to a JPEG. Usage: pdf2jpeg <input.pdf> [output.jpeg] [-p page_number]
pdf2jpeg() {
    local page=1
    local input=""
    local output=""

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -p|--page)
                page="$2"
                shift 2
                ;;
            *)
                if [ -z "$input" ]; then
                    input="$1"
                else
                    output="$1"
                fi
                shift
                ;;
        esac
    done

    if [ -z "$input" ]; then
        echo "Usage: pdf2jpeg <input.pdf> [output.jpeg] [-p page_number]" >&2
        return 2
    fi

    if [ -z "$output" ]; then
        output="${input%.pdf}.jpeg"
    fi

    local page_index=$((page - 1))
    magick -density 300 "${input}[$page_index]" -quality 90 "$output"
}
