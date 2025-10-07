#!/bin/bash
set -e

echo "📦 Installing essential packages for Arch Linux setup..."
echo ""

PACKAGES_DIR="$HOME/dot-files/packages"

if [ ! -f "$PACKAGES_DIR/pacman-explicit.txt" ]; then
    echo "❌ Error: Package list not found!"
    exit 1
fi

echo "Step 1: Update system"
echo "Run: sudo pacman -Syu"
read -p "Press enter when system is updated..."

echo ""
echo "Step 2: Install base packages from pacman"
PACMAN_PKGS=$(cat "$PACKAGES_DIR/pacman-explicit.txt" | tr '\n' ' ')
echo "Packages to install: $(wc -l < "$PACKAGES_DIR/pacman-explicit.txt")"
echo ""
echo "Run this command:"
echo "sudo pacman -S --needed $PACMAN_PKGS"

echo ""
echo "Step 3: Install AUR helper (if not present)"
if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
    echo "Installing yay..."
    echo "Run these commands:"
    echo "  cd /tmp"
    echo "  git clone https://aur.archlinux.org/yay.git"
    echo "  cd yay"
    echo "  makepkg -si"
fi

echo ""
echo "Step 4: Install AUR packages"
if [ -f "$PACKAGES_DIR/aur-packages.txt" ] && [ -s "$PACKAGES_DIR/aur-packages.txt" ]; then
    AUR_PKGS=$(cat "$PACKAGES_DIR/aur-packages.txt" | tr '\n' ' ')
    echo "Run this command:"
    echo "yay -S --needed $AUR_PKGS"
else
    echo "No AUR packages to install"
fi

echo ""
echo "Step 5: Install GNU Stow (if not already installed)"
echo "Run: sudo pacman -S --needed stow"

echo ""
echo "✅ Package installation commands ready!"
echo "Copy and run the commands above to install all packages."
