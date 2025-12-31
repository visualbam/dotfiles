#!/bin/bash

# WSL2/Linux-specific setup script
# Installs dependencies and configures the environment for WSL2 Ubuntu

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Setting up WSL2/Linux environment...${NC}"

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install required tools
echo ""
echo "Installing required packages..."

declare -a PACKAGES=(
    "neovim"
    "zsh"
    "git"
    "curl"
    "wget"
    "build-essential"
)

for package in "${PACKAGES[@]}"; do
    if dpkg -l | grep -q "^ii  $package"; then
        echo -e "${GREEN}✓ $package is installed${NC}"
    else
        echo -e "${YELLOW}Installing $package...${NC}"
        sudo apt-get install -y "$package"
    fi
done

# Install oh-my-posh
if ! command -v oh-my-posh &> /dev/null; then
    echo -e "${YELLOW}Installing oh-my-posh...${NC}"
    sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
    sudo chmod +x /usr/local/bin/oh-my-posh
else
    echo -e "${GREEN}✓ oh-my-posh is installed${NC}"
fi

# Install fnm (Node Version Manager)
if ! command -v fnm &> /dev/null; then
    echo -e "${YELLOW}Installing fnm...${NC}"
    curl -fsSL https://fnm.io/install | bash
else
    echo -e "${GREEN}✓ fnm is installed${NC}"
fi

# Install lazygit
if ! command -v lazygit &> /dev/null; then
    echo -e "${YELLOW}Installing lazygit...${NC}"
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit.tar.gz lazygit
else
    echo -e "${GREEN}✓ lazygit is installed${NC}"
fi

# Set zsh as default shell if not already
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo ""
    echo -e "${YELLOW}Setting zsh as default shell...${NC}"
    chsh -s /usr/bin/zsh
fi

# Initialize fnm
echo ""
echo -e "${YELLOW}Setting up Node.js version manager (fnm)...${NC}"
eval "$(fnm env --use-on-cd)"

echo ""
echo -e "${GREEN}✓ WSL2/Linux setup complete!${NC}"
echo ""
echo "WSL2-specific notes:"
echo "• Installed: neovim, zsh, git, oh-my-posh, fnm, lazygit"
echo "• Default shell has been set to zsh"
echo "• On Windows, wezterm will automatically open this WSL2 domain"
echo "• Next: Configure Windows Terminal or PowerShell profile if needed"
echo ""
