#!/bin/zsh

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "Stow is not installed. Please install it first."
    exit 1
fi

# Stow the contents of the zsh directory
stow -t ~/ zsh

mkdir ~/.config/alacritty
stow --target ~/.config/alacritty alacritty

mkdir ~/.config/nvim
stow --target ~/.config/nvim nvim
