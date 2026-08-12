# Dotfiles

## Getting Started:

Clone the repository

```bash
git clone https://github.com/stoneliuCS/dotfiles.git ~/dotfiles
```

Run the setup script. It's idempotent - installs whatever's missing (Homebrew,
Xcode Command Line Tools, all brew formulae/casks, rustup, nvm, Go tools, bun,
chruby/ruby-install, pyenv, pipx/uv, typescript-go, TPM), stows the dotfiles,
and updates everything already installed. Safe to re-run any time.

```bash
cd ~/dotfiles
./install.sh
```

> [!NOTE]
That sometimes the dracula ui won't load properly, when in the tmux session you can _leader_ (default is set to
ctr-a then I to install all dependencies.
