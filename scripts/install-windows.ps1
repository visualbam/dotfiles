# Dotfiles Installation Script for Windows
# Installs and configures dotfiles on Windows with WSL2
# Run this script as Administrator in PowerShell

# This script will:
# 1. Check if WSL2 is installed
# 2. Install wezterm if not present
# 3. Copy dotfiles to WSL2
# 4. Run setup scripts in WSL2

$ErrorActionPreference = "Stop"

Write-Host "Dotfiles Installation - Windows (WSL2)" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Red
    exit 1
}

# Check if WSL2 is installed
Write-Host "`nChecking for WSL2..." -ForegroundColor Yellow
try {
    $wslStatus = wsl.exe --list --verbose
    Write-Host "✓ WSL2 is installed" -ForegroundColor Green
} catch {
    Write-Host "✗ WSL2 is not installed" -ForegroundColor Red
    Write-Host "Please install WSL2 first: https://docs.microsoft.com/en-us/windows/wsl/install" -ForegroundColor Yellow
    exit 1
}

# Check if wezterm is installed
Write-Host "`nChecking for WezTerm..." -ForegroundColor Yellow
$weztermPath = Get-Command wezterm -ErrorAction SilentlyContinue
if ($weztermPath) {
    Write-Host "✓ WezTerm is installed at: $($weztermPath.Source)" -ForegroundColor Green
} else {
    Write-Host "✗ WezTerm not found in PATH" -ForegroundColor Red
    Write-Host "Install wezterm from: https://wezfurlong.org/wezterm/install/windows.html" -ForegroundColor Yellow
    Write-Host "Or install via Scoop: scoop install wezterm" -ForegroundColor Yellow
}

# Get the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$dotfilesDir = Split-Path -Parent $scriptDir

Write-Host "`nDotfiles directory: $dotfilesDir" -ForegroundColor Yellow

# Copy dotfiles to home directory in WSL2
Write-Host "`nSetting up dotfiles in WSL2..." -ForegroundColor Yellow

# Get the default WSL distribution
$defaultDist = (wsl.exe --list --default 2>$null) -replace '\s+$'

Write-Host "Using WSL2 distribution: $defaultDist" -ForegroundColor Yellow

# Copy configs to WSL2
Write-Host "`nCopying configuration files to WSL2..." -ForegroundColor Yellow

# Create directories in WSL2
wsl.exe mkdir -p ~/.config/nvim
wsl.exe mkdir -p ~/.config/wezterm
wsl.exe mkdir -p ~/.config/oh-my-posh
wsl.exe mkdir -p ~/.local/bin

# Convert Windows path to WSL path
$dotfilesWSL = wsl.exe wslpath -a "$dotfilesDir"

# Create symlinks in WSL2
Write-Host "Creating symlinks..." -ForegroundColor Yellow
wsl.exe ln -sf "$dotfilesWSL/config/nvim/init.lua" ~/.config/nvim/init.lua
wsl.exe ln -sf "$dotfilesWSL/config/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua
wsl.exe ln -sf "$dotfilesWSL/config/oh-my-posh/catppuccin.omp.json" ~/.config/oh-my-posh/catppuccin.omp.json
wsl.exe ln -sf "$dotfilesWSL/config/zsh/.zshrc" ~/.zshrc
wsl.exe ln -sf "$dotfilesWSL/bin/wezterm" ~/.local/bin/wezterm

Write-Host "✓ Symlinks created" -ForegroundColor Green

# Copy example files
Write-Host "`nCreating example configuration files..." -ForegroundColor Yellow
wsl.exe test -f ~/.config/wezterm/.wezterm-local.lua || wsl.exe cp "$dotfilesWSL/.wezterm-local.lua.example" ~/.config/wezterm/.wezterm-local.lua
wsl.exe test -f ~/.zshrc.local || wsl.exe cp "$dotfilesWSL/config/zsh/.zshrc.local.example" ~/.zshrc.local

Write-Host "✓ Example files created" -ForegroundColor Green

# Run setup script in WSL2
Write-Host "`nRunning WSL2 setup..." -ForegroundColor Yellow
wsl.exe bash "$dotfilesWSL/scripts/setup-wsl.sh"

Write-Host "`nInstallation complete!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Open a new WSL2 terminal in wezterm"
Write-Host "2. Review and customize ~/.zshrc.local if needed"
Write-Host "3. Review and customize ~/.config/wezterm/.wezterm-local.lua if needed"
Write-Host "4. Restart your terminal or run: source ~/.zshrc"
Write-Host "`nFor more information, see docs/WINDOWS_SETUP.md" -ForegroundColor Cyan
