# Dotfiles

## Getting Started:

Clone the repository

```bash
https://github.com/stoneliuCS/dotfiles.git ~/dotfiles
```
install brew
```bash 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

install nix 
```bash 
sh <(curl -L https://nixos.org/nix/install)
```

install mactex
```bash 
brew install --cask mactex
```

install GNU Stow
```bash 
brew install stow
```

Add symlinks to local machine:
```bash 
stow nvim 
stow git 
stow nix
```
