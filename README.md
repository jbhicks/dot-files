# dot-files

Dotfiles and system configuration for Arch Linux, managed with GNU Stow.

## 📁 Structure

```
dot-files/
├── home/              # GNU Stow package for ~/.config/
│   └── .config/       # All config directories (nvim, hypr, waybar, etc.)
├── shell/             # GNU Stow package for shell configs
│   ├── .bashrc
│   ├── .bash_profile
│   └── .gitconfig
├── packages/          # System state and package lists
│   ├── pacman-explicit.txt
│   ├── aur-packages.txt
│   ├── systemd-enabled-services.txt
│   └── docker-containers.txt
├── system/            # System-wide configurations
│   └── caddy/
└── scripts/           # Installation and restoration scripts
    ├── restore.sh
    └── install-packages.sh
```

## 🚀 Quick Start (New Machine)

### 1. Clone this repo
```bash
git clone https://github.com/jbhicks/dot-files.git ~/dot-files
```

### 2. Install packages
```bash
cd ~/dot-files
./scripts/install-packages.sh
# Follow the prompts and run the suggested commands
```

### 3. Restore dotfiles
```bash
./scripts/restore.sh
# This will use GNU Stow to symlink all configs
```

### 4. Restore sensitive files manually
Copy these from your backup:
- `~/.ssh/` (SSH keys)
- `~/.gnupg/` (GPG keys)
- `~/.git-credentials`
- `~/.docker/config.json`

## 🔧 Using GNU Stow

Stow creates symlinks from this repo to your home directory.

### Install configs
```bash
cd ~/dot-files
stow shell    # Symlinks shell configs to ~/
stow -d home -t ~ .  # Symlinks .config/ to ~/.config/
```

### Remove configs
```bash
cd ~/dot-files
stow -D shell
```

### Re-stow (update symlinks)
```bash
cd ~/dot-files
stow -R shell
```

## 📦 Updating Package Lists

When you install new packages on your current system:

```bash
# Update package lists
pacman -Qqe > ~/dot-files/packages/pacman-explicit.txt
pacman -Qqm > ~/dot-files/packages/aur-packages.txt

# Update service lists
systemctl list-unit-files --type=service --state=enabled > ~/dot-files/packages/systemd-enabled-services.txt
```

## 🔐 Security Notes

The following are **NOT** stored in this repo (see `.gitignore`):
- SSH keys
- GPG keys
- Git credentials
- TLS certificates
- Any `*.key`, `*.pem`, `*.crt` files

Always backup these separately and restore them manually.

## 📋 What's Included

**Shell configs:**
- bash
- git
- starship prompt

**Development tools:**
- nvim (Neovim config)
- lazygit
- mise (runtime manager)
- gh (GitHub CLI)

**Desktop environment:**
- hyprland (Wayland compositor)
- waybar (status bar)
- alacritty, wezterm (terminals)
- mako (notifications)

**System services:**
- Docker (11 containers)
- Caddy (web server)
- Tailscale
- SSH server

## 🔄 Workflow

### On current system (before migration):
1. Update package lists
2. Commit and push changes

### On new system:
1. Install Arch Linux
2. Clone this repo
3. Run `install-packages.sh`
4. Run `restore.sh`
5. Restore sensitive files manually
6. Reboot

## 📝 Notes

- Total packages: 149 (pacman) + 13 (AUR)
- Config directories: 16 in `~/.config/`
- Docker containers: 11
- Systemd services: 18 enabled

Generated: 2025-10-07
