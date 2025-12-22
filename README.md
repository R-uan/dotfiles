
# NixOS Dotfiles

A declarative NixOS configuration using flakes and Home Manager for reproducible system and user environment management.

## 📋 Overview

This repository contains my personal NixOS system configuration, managed through Nix flakes for improved reproducibility and Home Manager for user-level package and dotfile management.

## 🔧 Prerequisites

- NixOS installed with flakes enabled
- Git for cloning the repository

## 📦 Installation

### Initial Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Enable flakes** (if not already enabled):
   Add to `/etc/nixos/configuration.nix`:
   ```nix
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   ```

3. **Build and switch:**
   ```bash
   sudo nixos-rebuild switch --flake .#hostname
   ```

### Fresh Installation

When installing NixOS from scratch:

```bash
# After basic installation
git clone https://github.com/yourusername/dotfiles.git /mnt/etc/nixos
cd /mnt/etc/nixos
nixos-install --flake .#hostname
```

## 🖥️ Usage

### Rebuilding System

```bash
# From the dotfiles directory
sudo nixos-rebuild switch --flake .#hostname
```

## 🔄 Rollback

```bash
# List generations
sudo nixos-rebuild list-generations

# Switch to previous generation
sudo nixos-rebuild switch --rollback

# Boot into specific generation (from GRUB menu)
# Select generation at boot time
```

#### TODO
- Taskbar drop down
- Wallpaper Selector
- Power buttons
