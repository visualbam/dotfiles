# Windows/WSL2 Setup Guide

Detailed setup guide for Windows with WSL2, covering installation, configuration, and troubleshooting.

## System Requirements

- Windows 10 (build 19041 or later) or Windows 11
- WSL2 installed with Ubuntu 20.04 LTS or later
- Administrator access in PowerShell
- 2 GB free disk space (minimum)

## WSL2 Prerequisites

### Checking WSL2 Installation

```powershell
# Check if WSL2 is installed
wsl --list --verbose

# Expected output should show Ubuntu with VERSION = 2
```

### Installing WSL2 (if not already installed)

```powershell
# Run as Administrator
wsl --install

# This installs WSL2 and Ubuntu by default
# Then restart your computer

# After restart, complete Ubuntu setup
```

## Installation Overview

The Windows/WSL2 setup installs everything inside WSL2 (Ubuntu):
- All CLI tools (nvim, zsh, oh-my-posh, etc.) run in WSL2
- WezTerm on Windows automatically opens WSL2 domain
- Seamless integration between Windows and WSL2

## Installation Steps

### Step 1: Clone Repository

**Option A: In WSL2 Terminal**
```bash
git clone https://github.com/visualbam/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**Option B: From Windows PowerShell**
```powershell
git clone https://github.com/visualbam/dotfiles.git %USERPROFILE%\dotfiles
cd %USERPROFILE%\dotfiles
```

### Step 2: Run Installation

**Option A: From WSL2 Terminal**
```bash
bash ~/dotfiles/scripts/install.sh
```

**Option B: From Windows PowerShell (Recommended)**
```powershell
# Right-click PowerShell → "Run as Administrator"
cd %USERPROFILE%\dotfiles
powershell -ExecutionPolicy Bypass -File scripts/install-windows.ps1
```

The PowerShell script will:
1. Verify WSL2 installation
2. Check/install WezTerm
3. Create symlinks in WSL2
4. Run Linux setup scripts inside WSL2

### Step 3: Install WezTerm (if needed)

If WezTerm wasn't installed by the script:

**Using Scoop** (recommended):
```powershell
# Install Scoop first if needed
iwr -useb get.scoop.sh | iex

# Then install WezTerm
scoop install wezterm
```

**Using Winget**:
```powershell
winget install JanDeDobbeleer.oh-my-posh
winget install wezterm
```

**Manual Installation**:
Download from https://wezfurlong.org/wezterm/install/windows.html

### Step 4: Configure WezTerm (Windows Side)

Create or edit WezTerm configuration on Windows:

```powershell
# Navigate to config directory
cd $env:APPDATA\wezterm

# Create wezterm.lua if it doesn't exist
notepad wezterm.lua
```

Add this configuration:

```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Define WSL2 domain
config.wsl_domains = {
  {
    name = 'WSL:Ubuntu',
    distribution = 'Ubuntu',
    default_cwd = '/home/yourusername',
  },
}

-- Set WSL2 as default domain
config.default_domain = 'WSL:Ubuntu'

-- Enable key forwarding for Ctrl+a
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Import any additional settings
pcall(function() return require 'wezterm-local' end)

return config
```

Replace `yourusername` with your actual WSL2 username.

### Step 5: Verify Installation in WSL2

Open WezTerm and verify everything is installed:

```bash
# Check tools are installed
nvim --version
zsh --version
oh-my-posh --version
lazygit --version

# Check symlinks
ls -la ~/.config/nvim/init.lua
ls -la ~/.zshrc
```

### Step 6: Final Configuration

In WSL2 terminal:

```bash
# Customize local configuration
vim ~/.config/wezterm/.wezterm-local.lua
vim ~/.zshrc.local

# Reload shell
exec zsh
```

## WSL2-Specific Configuration

### Setting Default WSL Distribution

```powershell
# Check installed distributions
wsl --list --verbose

# Set default to Ubuntu
wsl --set-default Ubuntu
```

### WSL2 Network Access

To access services running in WSL2 from Windows:

```bash
# Inside WSL2, get your IP
hostname -I

# Use this IP from Windows to access services
# Example: http://172.x.x.x:8000
```

### File System Access

Access WSL2 files from Windows:

```powershell
# Open WSL2 home directory from Windows
explorer.exe \\wsl$\Ubuntu\home\yourusername
```

Access Windows files from WSL2:

```bash
# Windows drives are mounted at /mnt/
ls /mnt/c/Users/yourusername/Documents
```

## Customizing Your Setup

### Local WezTerm Configuration (WSL2)

Create `~/.config/wezterm/.wezterm-local.lua`:

```lua
local wezterm = require 'wezterm'

return {
  -- Define custom workspaces
  workspaces = {
    {
      name = 'main',
      panes = {
        { cwd = wezterm.home_dir },
      }
    },
    {
      name = 'projects',
      panes = {
        { cwd = wezterm.home_dir .. '/projects' },
      }
    },
  }
}
```

### Local Shell Configuration (WSL2)

Create `~/.zshrc.local`:

```bash
# Machine-specific aliases
alias projects='cd ~/projects'
alias code='cd /mnt/c/Users/yourusername/Documents'

# Custom environment variables
export PROJECTS_DIR=~/projects

# Custom functions
function wsl-ip() {
  hostname -I
}
```

### WSL-Specific Environment Variables

In `~/.zshrc.local`:

```bash
# Check if running in WSL2
if grep -qi microsoft /proc/version &> /dev/null; then
  echo "Running in WSL2"
  
  # WSL2-specific settings
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
fi
```

## Neovim in WSL2

### Using Neovim from Windows

You can edit Windows files from Neovim in WSL2:

```bash
# Edit Windows documents from WSL2
nvim /mnt/c/Users/yourusername/Documents/file.txt
```

### Custom Neovim Config for WSL2

Create `~/.config/nvim/init.local.lua`:

```lua
-- WSL2-specific Neovim configuration
-- Check if running in WSL2
local is_wsl = vim.fn.has('wsl') == 1

if is_wsl then
  -- WSL2-specific settings
  vim.g.clipboard = {
    name = 'wslclip',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::In.ReadToEnd()',
      ['*'] = 'powershell.exe -c [Console]::In.ReadToEnd()',
    },
  }
end
```

## WSL2 Development Workflow

### Accessing Git from Windows

Git credentials can be shared between Windows and WSL2:

```bash
# Configure Git in WSL2 to use Windows Git credential manager
git config --global credential.helper "/mnt/c/Program Files/Git/mingw64/libexec/git-core/git-credential-manager.exe"
```

### Syncing SSH Keys

Share SSH keys between Windows and WSL2:

```bash
# Copy SSH keys from Windows to WSL2
cp -r /mnt/c/Users/yourusername/.ssh ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
```

### Node.js Development

fnm is pre-installed. Switch Node versions:

```bash
# Install Node 18
fnm install 18

# Use Node 18
fnm use 18

# Set as default
fnm default 18
```

## Troubleshooting Windows/WSL2

### Issue: WSL2 Not Installed

**Problem**: `wsl` command not found or WSL version is 1

**Solution**:
```powershell
# Check WSL version
wsl --list --verbose

# If version is 1, upgrade to WSL2
wsl --set-version Ubuntu 2

# If not installed at all
wsl --install
```

### Issue: WezTerm Can't Connect to WSL2

**Problem**: WezTerm opens but doesn't show Ubuntu domain

**Solution**:
```powershell
# Check available distributions
wsl --list --verbose

# Verify wezterm.lua has correct distribution name
notepad $env:APPDATA\wezterm\wezterm.lua
# Check that distribution = 'Ubuntu' matches your installed distro
```

### Issue: Symlinks Not Created in WSL2

**Problem**: `ln -s` fails or creates copies instead of symlinks

**Solution**:
```bash
# WSL2 may have symlink restrictions enabled
# Check wsl.conf
cat /etc/wsl.conf

# Add this to /etc/wsl.conf if needed:
# [interop]
# appendWindowsPath = false
# [wsl2]
# kernelCommandLine = "sysctl.fs.mqueue.msg_max=98304"

# Then restart WSL2 from PowerShell
wsl --shutdown
wsl
```

### Issue: Slow File Access in WSL2

**Problem**: Accessing Windows files from WSL2 is very slow

**Solution**:
- Keep your dotfiles and projects in WSL2 home directory, not `/mnt/c/`
- Use `/home/username/` instead of `/mnt/c/Users/username/`

```bash
# Good: Files in WSL2 native storage (fast)
cd ~/projects
nvim myfile.txt

# Slower: Files in Windows
cd /mnt/c/Users/username/Projects
nvim myfile.txt
```

### Issue: Clipboard Not Working Between WSL2 and Windows

**Problem**: Can't copy/paste between WSL2 and Windows

**Solution**:
```bash
# Install wl-clipboard in WSL2
sudo apt-get install wl-clipboard

# Verify it works
echo "test" | wl-copy
wl-paste
```

### Issue: SSH Keys Not Working in WSL2

**Problem**: SSH authentication fails in WSL2

**Solution**:
```bash
# Check SSH key permissions
ls -la ~/.ssh/

# Fix permissions if needed
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

# Test SSH connection
ssh -vv git@github.com
```

### Issue: zsh or oh-my-posh Not Found

**Problem**: Shell commands not in PATH after installation

**Solution**:
```bash
# Check if packages installed correctly
sudo apt-get update
sudo apt-get install -y zsh
sudo apt-get install -y neovim

# Reinstall oh-my-posh
curl -s https://ohmyposh.dev/install/linux.sh | bash

# Set zsh as default
chsh -s /usr/bin/zsh
```

### Issue: Permission Denied Errors

**Problem**: `Permission denied` when running scripts or installation

**Solution**:
```bash
# Run install.sh with bash explicitly
bash ~/dotfiles/scripts/install.sh

# Not:
./scripts/install.sh

# For PowerShell script, ensure Administrator mode
# Right-click PowerShell → "Run as Administrator"
```

## WSL2 Performance Tips

### Optimize WSL2 Settings

Create or edit `%USERPROFILE%\.wslconfig`:

```ini
[wsl2]
# Limit memory usage
memory=4GB
# Limit CPU cores
processors=4
# Swap file size
swap=2GB
# Localhostforwarding
localhostforwarding=true
```

Then restart WSL2:

```powershell
wsl --shutdown
wsl
```

### Monitor WSL2 Resources

```powershell
# Check WSL2 memory/CPU usage
Get-Process | Where-Object { $_.ProcessName -like "*wsl*" } | Format-Table Name, @{Name='Memory(MB)';Expression={[math]::Round($_.WS/1MB)}}
```

## Next Steps

- Read [Troubleshooting Guide](TROUBLESHOOTING.md) for additional help
- Review [Architecture Guide](ARCHITECTURE.md) to understand system integration
- Customize your `.zshrc.local` and `.wezterm-local.lua` files
- Explore Neovim configuration by editing `~/.config/nvim/init.lua`

## Additional Resources

- [WSL2 Official Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [WezTerm Configuration](https://wezfurlong.org/wezterm/config/index.html)
- [Ubuntu in WSL2](https://wiki.ubuntu.com/WSL)
- [Neovim Documentation](https://neovim.io/doc/user/)
- [Oh-My-Posh Documentation](https://ohmyposh.dev/)
