#!/bin/zsh

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "Stow is not installed. Please install it first."
    exit 1
fi

# Stow the contents of the zsh directory
stow -t ~/ zsh

echo "Stowing of zsh configuration complete."
