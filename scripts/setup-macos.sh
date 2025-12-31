#!/bin/bash

# macOS-specific setup script
# Installs dependencies and configures the environment for macOS

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Setting up macOS environment...${NC}"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Homebrew not found. Installing...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}✓ Homebrew is installed${NC}"
fi

# Install required tools
echo ""
echo "Installing required packages..."

declare -a PACKAGES=(
    "neovim"
    "zsh"
    "oh-my-posh"
    "fnm"
    "wezterm"
    "git"
    "lazygit"
)

for package in "${PACKAGES[@]}"; do
    if brew list "$package" &>/dev/null; then
        echo -e "${GREEN}✓ $package is installed${NC}"
    else
        echo -e "${YELLOW}Installing $package...${NC}"
        brew install "$package"
    fi
done

# Set zsh as default shell if not already
if [ "$SHELL" != "$(brew --prefix)/bin/zsh" ]; then
    echo ""
    echo -e "${YELLOW}Setting zsh as default shell...${NC}"
    chsh -s "$(brew --prefix)/bin/zsh"
fi

# Initialize fnm
echo ""
echo -e "${YELLOW}Setting up Node.js version manager (fnm)...${NC}"
eval "$(fnm env --use-on-cd)"

echo ""
echo -e "${GREEN}✓ macOS setup complete!${NC}"
echo ""
echo "macOS-specific notes:"
echo "• Homebrew has installed: neovim, zsh, oh-my-posh, fnm, wezterm, git, lazygit"
echo "• Default shell has been set to zsh"
echo "• Next: Configure wezterm to open on startup (optional)"
echo ""
