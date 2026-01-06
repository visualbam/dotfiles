#!/bin/bash

# Dotfiles Installation Script
# Installs symlinks and sets up the environment on macOS or Linux

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
    PLATFORM_SCRIPT="scripts/setup-macos.sh"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    PLATFORM_SCRIPT="scripts/setup-wsl.sh"
else
    echo -e "${RED}Unsupported OS: $OSTYPE${NC}"
    exit 1
fi

echo -e "${GREEN}Dotfiles Installation - $OS${NC}"
echo "========================================"

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
echo -e "${YELLOW}Dotfiles directory: $DOTFILES_DIR${NC}"

# Create required directories
echo "Creating directories..."
mkdir -p ~/.config/nvim
mkdir -p ~/.config/wezterm
mkdir -p ~/.config/oh-my-posh
mkdir -p ~/.config/helix
mkdir -p ~/.config/yazi
mkdir -p ~/.local/bin

# Function to create symlink
create_symlink() {
    local src="$1"
    local dest="$2"
    local name="$3"
    
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo -e "${YELLOW}Backing up existing $name to ${dest}.backup${NC}"
        mv "$dest" "${dest}.backup"
    fi
    
    if [ -L "$dest" ]; then
        rm "$dest"
    fi
    
    ln -s "$src" "$dest"
    echo -e "${GREEN}✓ Linked $name${NC}"
}

# Create symlinks
echo ""
echo "Creating symlinks..."
create_symlink "$DOTFILES_DIR/config/nvim/init.lua" "$HOME/.config/nvim/init.lua" "nvim config"
create_symlink "$DOTFILES_DIR/config/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua" "wezterm config"
create_symlink "$DOTFILES_DIR/config/oh-my-posh/catppuccin.omp.json" "$HOME/.config/oh-my-posh/catppuccin.omp.json" "oh-my-posh theme"
create_symlink "$DOTFILES_DIR/config/helix/config.toml" "$HOME/.config/helix/config.toml" "helix config"
create_symlink "$DOTFILES_DIR/config/helix/languages.toml" "$HOME/.config/helix/languages.toml" "helix languages"
create_symlink "$DOTFILES_DIR/config/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml" "yazi config"
create_symlink "$DOTFILES_DIR/config/zsh/.zshrc" "$HOME/.zshrc" "zsh config"
create_symlink "$DOTFILES_DIR/bin/wezterm" "$HOME/.local/bin/wezterm" "wezterm wrapper"

# Create example files if they don't exist
echo ""
echo "Creating example configuration files..."
if [ ! -f "$HOME/.config/wezterm/.wezterm-local.lua" ]; then
    cp "$DOTFILES_DIR/.wezterm-local.lua.example" "$HOME/.config/wezterm/.wezterm-local.lua"
    echo -e "${GREEN}✓ Created .wezterm-local.lua (you can customize this)${NC}"
fi

if [ ! -f "$HOME/.zshrc.local" ]; then
    cp "$DOTFILES_DIR/config/zsh/.zshrc.local.example" "$HOME/.zshrc.local"
    echo -e "${GREEN}✓ Created .zshrc.local (you can customize this)${NC}"
fi

# Run platform-specific setup
echo ""
echo "Running platform-specific setup for $OS..."
if [ -f "$DOTFILES_DIR/$PLATFORM_SCRIPT" ]; then
    bash "$DOTFILES_DIR/$PLATFORM_SCRIPT"
else
    echo -e "${YELLOW}Platform script not found: $PLATFORM_SCRIPT${NC}"
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Review and customize ~/.zshrc.local if needed"
echo "2. Review and customize ~/.config/wezterm/.wezterm-local.lua if needed"
echo "3. Restart your terminal or run: source ~/.zshrc"
echo ""
