#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dot-files"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo "🚀 Restoring system configuration from dot-files..."
echo ""

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "❌ Error: $DOTFILES_DIR not found!"
    echo "Run: git clone https://github.com/jbhicks/dot-files.git ~/dot-files"
    exit 1
fi

cd "$DOTFILES_DIR"

echo "📦 Step 1: Installing packages..."
echo "This will install pacman packages, AUR packages, and enable services"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f packages/pacman-explicit.txt ]; then
        echo "Installing pacman packages..."
        echo "Run this command manually:"
        echo "  sudo pacman -S --needed \$(cat ~/dot-files/packages/pacman-explicit.txt)"
    fi
    
    if [ -f packages/aur-packages.txt ]; then
        echo ""
        echo "Installing AUR packages (requires yay or paru)..."
        echo "Run this command manually:"
        echo "  yay -S --needed \$(cat ~/dot-files/packages/aur-packages.txt)"
    fi
fi

echo ""
echo "📁 Step 2: Backing up existing dotfiles..."
mkdir -p "$BACKUP_DIR"
[ -f ~/.bashrc ] && cp ~/.bashrc "$BACKUP_DIR/"
[ -f ~/.bash_profile ] && cp ~/.bash_profile "$BACKUP_DIR/"
[ -f ~/.gitconfig ] && cp ~/.gitconfig "$BACKUP_DIR/"
echo "Backup created at: $BACKUP_DIR"

echo ""
echo "🔗 Step 3: Installing dotfiles with GNU Stow..."
if ! command -v stow &> /dev/null; then
    echo "⚠️  GNU Stow not found. Installing..."
    echo "Run: sudo pacman -S stow"
    read -p "Press enter when stow is installed..."
fi

echo "Symlinking shell configs..."
if [ -d "$DOTFILES_DIR/shell" ]; then
    cd "$DOTFILES_DIR"
    stow -t ~ shell 2>&1 | grep -v "BUG in find_stowed_path" || true
fi

echo "Symlinking .config directories..."
if [ -d "$DOTFILES_DIR/home/.config" ]; then
    mkdir -p ~/.config
    for dir in "$DOTFILES_DIR/home/.config"/*; do
        dirname=$(basename "$dir")
        if [ -e ~/.config/"$dirname" ]; then
            echo "  ⚠️  ~/.config/$dirname exists, backing up..."
            mv ~/.config/"$dirname" "$BACKUP_DIR/config-$dirname"
        fi
    done
    cd "$DOTFILES_DIR/home"
    stow -t ~ . 2>&1 | grep -v "BUG in find_stowed_path" || true
fi

echo ""
echo "🔧 Step 4: Enabling system services..."
if [ -f packages/systemd-enabled-services.txt ]; then
    echo "Services to enable:"
    grep "enabled" packages/systemd-enabled-services.txt | awk '{print "  - " $1}'
    echo ""
    echo "Run these commands manually (requires sudo):"
    grep "enabled" packages/systemd-enabled-services.txt | awk '{print "sudo systemctl enable " $1}' | head -20
fi

echo ""
echo "🐳 Step 5: Docker containers..."
if [ -f packages/docker-compose-files.txt ]; then
    echo "Docker compose files found on old system:"
    cat packages/docker-compose-files.txt
    echo ""
    echo "⚠️  You'll need to manually copy docker-compose.yml files and data volumes"
fi

echo ""
echo "⚙️  Step 6: System-specific configs..."
if [ -d system/caddy ]; then
    echo "Caddy config found. Copy to appropriate location:"
    echo "  sudo cp -r $DOTFILES_DIR/system/caddy/* /etc/caddy/"
fi

echo ""
echo "✅ Dotfiles restoration complete!"
echo ""
echo "📋 Manual steps remaining:"
echo "  1. Install packages (see commands above)"
echo "  2. Enable systemd services (requires sudo)"
echo "  3. Restore Docker containers and volumes"
echo "  4. Restore sensitive files (SSH keys, GPG keys, credentials)"
echo "  5. Reboot or re-login to apply all changes"
echo ""
echo "🔑 Don't forget to restore:"
echo "  - ~/.ssh/ (SSH keys)"
echo "  - ~/.gnupg/ (GPG keys)"
echo "  - ~/.git-credentials (Git credentials)"
echo "  - ~/.docker/config.json (Docker credentials)"
