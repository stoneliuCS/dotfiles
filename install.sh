#!/bin/bash

set -euo pipefail

have() { command -v "$1" >/dev/null 2>&1; }

log() { printf '\n==> %s\n' "$1"; }

# pipx/uv install their shims here; needed on PATH within this script's own
# run, not just in future interactive shells.
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# Homebrew + Xcode Command Line Tools
# ---------------------------------------------------------------------------

if ! have brew; then
	log "Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

if ! xcode-select -p >/dev/null 2>&1; then
	log "Installing Xcode Command Line Tools"
	xcode-select --install
fi

# ---------------------------------------------------------------------------
# Homebrew taps, formulae, casks
# ---------------------------------------------------------------------------

log "Tapping third-party brew repositories"
for t in go-task/tap heroku/brew supabase/tap browsh-org/browsh leohenon/tap anomalyco/tap; do
	brew tap "$t"
done

log "Installing brew formulae"
brew install \
	automake basedpyright bat bison chruby cmake cocoapods coreutils curl \
	difftastic discount docker-compose-langserver dockerfile-language-server \
	doctl duti exiftool fastlane fd ffmpeg flex fzf gh git go gperf gradle \
	gradle-completion graphviz hadolint imagemagick jq jupyterlab just \
	latexindent lazygit lf lua-language-server luarocks maven mise mongosh \
	neovim ninja pandoc pipx postgresql@14 potrace pyenv pyright qemu ripgrep \
	rsync ruby-install stow stylua tailwindcss-language-server texlab \
	tinymist tmux tree tree-sitter-cli typst w3m wget xcode-build-server \
	xcodegen yaml-language-server yt-dlp go-task/tap/go-task heroku/brew/heroku \
	supabase/tap/supabase browsh-org/browsh/browsh leohenon/tap/ocv \
	anomalyco/tap/opencode

log "Installing brew casks"
brew install --cask \
	kitty mactex skim sioyek shortcat font-jetbrains-mono-nerd-font \
	ngrok vagrant vagrant-manager virtualbox temurin@11 temurin@8

# ---------------------------------------------------------------------------
# Rust (rustup, cargo)
# ---------------------------------------------------------------------------

if ! have rustup; then
	log "Installing rustup"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
# shellcheck disable=SC1091
source "$HOME/.cargo/env"

log "Installing rustup components"
rustup component add rust-analyzer rustfmt clippy

if ! have typstyle; then
	log "Installing cargo packages"
	cargo install --locked typstyle
fi

# ---------------------------------------------------------------------------
# Node (nvm) + npm globals
# ---------------------------------------------------------------------------

if [ ! -d "$HOME/.nvm" ]; then
	log "Installing nvm"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

log "Installing latest LTS Node"
nvm install --lts
nvm alias default 'lts/*'
corepack enable

if ! have vtsls; then
	log "Installing npm globals"
	npm install -g @vtsls/language-server
fi

# salesforce-cli's Homebrew cask is deprecated (fails macOS Gatekeeper, being
# disabled 2026-09-01) and its installer needs an interactive sudo password,
# so install via npm instead - Salesforce's own recommended cross-platform path.
if ! have sf; then
	log "Installing Salesforce CLI"
	npm install -g @salesforce/cli
fi

# ---------------------------------------------------------------------------
# Go tools
# ---------------------------------------------------------------------------

log "Installing Go tools"
have gopls || go install golang.org/x/tools/gopls@latest
have goimports || go install golang.org/x/tools/cmd/goimports@latest
have templ || go install github.com/a-h/templ/cmd/templ@latest
have dlv || go install github.com/go-delve/delve/cmd/dlv@latest

# ---------------------------------------------------------------------------
# Bun
# ---------------------------------------------------------------------------

if ! have bun; then
	log "Installing bun"
	curl -fsSL https://bun.sh/install | bash
fi

# ---------------------------------------------------------------------------
# Ruby (chruby + ruby-install)
# ---------------------------------------------------------------------------

RUBY_VERSION="3.4.1"
if [ ! -d "$HOME/.rubies/ruby-$RUBY_VERSION" ]; then
	log "Installing Ruby $RUBY_VERSION"
	ruby-install ruby "$RUBY_VERSION"
fi

# ---------------------------------------------------------------------------
# Python (pyenv, pipx, uv)
# ---------------------------------------------------------------------------

# Captured once into a variable and matched in pure bash (not `| grep -q`):
# under `pipefail`, grep -q exits the instant it finds a match, which for an
# early hit closes the pipe while pyenv is still writing later lines, sending
# it SIGPIPE - and that failure, not grep's success, is what pipefail reports.
installed_pyenv_versions="$(pyenv versions --bare 2>/dev/null || true)"
for pyver in 3.10.19 3.11.13; do
	case $'\n'"$installed_pyenv_versions"$'\n' in
	*$'\n'"$pyver"$'\n'*) continue ;;
	esac
	log "Installing Python $pyver via pyenv"
	pyenv install "$pyver"
done

if have pipx; then
	log "Installing pipx tools"
	pipx install ruff
	pipx install uv
fi

if have uv; then
	log "Installing uv-managed tools"
	uv tool install euporie
fi

# ---------------------------------------------------------------------------
# typescript-go (tsgo) - built from source, no package available yet
# See https://www.reddit.com/r/neovim/comments/1kk63nb/typescript_go_lsp/
# ---------------------------------------------------------------------------

if [ ! -x "$HOME/typescript-go/built/local/tsgo" ]; then
	log "Building typescript-go (tsgo)"
	git clone --recursive --depth 1 https://github.com/microsoft/typescript-go.git "$HOME/typescript-go"
	(cd "$HOME/typescript-go" && npm ci && npm run build)
fi

# ---------------------------------------------------------------------------
# Apex Language Server (apex-jorje-lsp.jar) - not on Homebrew; the jar only
# ships bundled inside the salesforcedx-vscode-apex VS Code extension's
# .vsix (itself just a zip), so pull it straight from that extension's
# GitHub release instead.
# ---------------------------------------------------------------------------

APEX_LS_VERSION="67.10.0"
APEX_LS_DIR="$HOME/.local/share/apex-language-server"
if [ ! -f "$APEX_LS_DIR/apex-jorje-lsp.jar" ]; then
	log "Installing Apex Language Server $APEX_LS_VERSION"
	mkdir -p "$APEX_LS_DIR"
	tmp_vsix="$(mktemp)"
	curl -fsSL -o "$tmp_vsix" \
		"https://github.com/forcedotcom/salesforcedx-vscode/releases/download/v${APEX_LS_VERSION}/salesforcedx-vscode-apex-${APEX_LS_VERSION}.vsix"
	unzip -p "$tmp_vsix" extension/dist/apex-jorje-lsp.jar >"$APEX_LS_DIR/apex-jorje-lsp.jar"
	rm "$tmp_vsix"
fi

# ---------------------------------------------------------------------------
# Dotfiles (GNU Stow)
# ---------------------------------------------------------------------------

log "Stowing dotfiles"
cd "$(dirname "${BASH_SOURCE[0]}")"
stow --restow nvim git nix tmux zshrc kitty inputrc scripts claude

# ---------------------------------------------------------------------------
# Tmux Plugin Manager
# ---------------------------------------------------------------------------

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	log "Installing Tmux Plugin Manager"
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
"$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"

# ---------------------------------------------------------------------------
# Keep everything up to date
# ---------------------------------------------------------------------------

log "Updating Homebrew packages"
brew update
brew upgrade
brew cleanup

log "Updating npm globals"
npm update -g

log "Updating rustup"
rustup update

log "Done"
