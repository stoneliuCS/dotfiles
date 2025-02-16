# Dotfiles

## Getting Started:

Clone the repository

```bash
https://github.com/stoneliuCS/dotfiles.git ~/dotfiles
```

Add sym links to the necessary configs

```bash
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.config/nix ~/.config/nvim
ln -s ~/dotfiles/.config/git ~/.config/git
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
