#!/bin/zsh

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "Stow is not installed. Please install it first."
    exit 1
fi

# Stow the contents of the zsh directory
stow zsh

mkdir ~/.config/alacritty
stow -t ~/.config/alacritty alacritty

mkdir ~/.config/nvim
stow -t ~/.config/nvim nvim

mkdir ~/.newsboat
stow -t ~/.newsboat newsboat

stow -t ~ tmux
stow -t ~/.config/i3 i3
