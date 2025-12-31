# Installation Guide

This guide provides step-by-step instructions for installing the dotfiles on macOS or Windows with WSL2.

## Prerequisites

### All Platforms
- Git installed and configured
- Administrator access (Windows) or sudo access (macOS/Linux)

### macOS
- macOS 10.13 or later
- Homebrew will be installed if not present

### Windows with WSL2
- Windows 10 (build 19041) or Windows 11
- WSL2 installed with Ubuntu
- Administrator access in PowerShell

## Installation Steps

### Option 1: macOS

#### Step 1: Clone the Repository

```bash
git clone https://github.com/visualbam/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

#### Step 2: Run the Installation Script

```bash
bash scripts/install.sh
```

This script will:
1. Create required directories (`~/.config`, `~/.local/bin`)
2. Create symlinks to configuration files
3. Create example configuration files if they don't exist
4. Run `scripts/setup-macos.sh` to install dependencies

#### Step 3: Verify Installation

```bash
# Check nvim config
nvim --version

# Check wezterm
wezterm --version

# Check zsh
zsh --version
```

#### Step 4: Customize (Optional)

Edit the machine-specific files:

```bash
# Edit local wezterm config
vim ~/.config/wezterm/.wezterm-local.lua

# Edit local zsh config
vim ~/.zshrc.local
```

---

### Option 2: Windows with WSL2

#### Step 1: Ensure WSL2 is Installed

```powershell
# Open PowerShell and check WSL2
wsl --list --verbose

# If WSL2 is not installed, run:
wsl --install
# Then restart your computer
```

#### Step 2: Clone the Repository (in WSL2)

```bash
# In WSL2 terminal
git clone https://github.com/visualbam/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Or clone from Windows PowerShell and it will automatically work in WSL2.

#### Step 3: Run the Installation Script

**Option A: From WSL2 Terminal**

```bash
bash ~/dotfiles/scripts/install.sh
```

**Option B: From Windows PowerShell (as Administrator)**

```powershell
# Right-click PowerShell and select "Run as Administrator"
cd %USERPROFILE%\dotfiles
powershell -ExecutionPolicy Bypass -File scripts/install-windows.ps1
```

The PowerShell script will:
1. Verify WSL2 is installed
2. Check if WezTerm is installed (installs if missing)
3. Create symlinks in WSL2
4. Run setup scripts inside WSL2

#### Step 4: Install WezTerm (if not already done)

If the PowerShell script couldn't install WezTerm, install manually:

**Option A: Using Scoop**
```powershell
scoop install wezterm
```

**Option B: Using Winget**
```powershell
winget install JanDeDobbeleer.oh-my-posh
```

**Option C: Manual Download**
Download from https://wezfurlong.org/wezterm/install/windows.html

#### Step 5: Verify Installation in WSL2

```bash
# Inside WSL2 terminal
nvim --version
oh-my-posh --version
zsh --version
```

#### Step 6: Configure WezTerm (Windows Native)

Edit WezTerm configuration on Windows:
- Windows config path: `%APPDATA%\wezterm\wezterm.lua`
- Or use: `$env:APPDATA + "\wezterm\wezterm.lua"`

Example configuration to add WSL2 domain:

```lua
-- %APPDATA%\wezterm\wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.wsl_domains = {
  {
    name = 'WSL:Ubuntu',
    distribution = 'Ubuntu',
    default_cwd = '/home/yourusername',
  },
}

config.default_domain = 'WSL:Ubuntu'

return config
```

#### Step 7: Customize (Optional)

Edit the machine-specific files in WSL2:

```bash
# Edit local wezterm config
vim ~/.config/wezterm/.wezterm-local.lua

# Edit local zsh config
vim ~/.zshrc.local
```

---

## Post-Installation

After installation on either platform:

### 1. Restart Your Terminal

Close and reopen your terminal to apply all configuration changes.

### 2. Check Symlinks

Verify that symlinks are correctly created:

```bash
# macOS/Linux
ls -la ~/.config/nvim/init.lua
ls -la ~/.zshrc
ls -la ~/.local/bin/wezterm
```

### 3. Test Navigation

Test the smart navigation:

1. Open a new terminal with multiple panes
2. Try `Ctrl+h/j/k/l` to navigate between panes
3. Try `Alt+h/j/k/l` to resize panes
4. Open Neovim and test navigation within splits

### 4. Verify Theme

Check that your terminal theme is correctly applied:

```bash
# Test theme switching
catppuccin mocha   # Switch to mocha theme
catppuccin latte   # Switch to latte (light) theme
```

---

## Troubleshooting Installation

### Issue: "Permission denied" when running install.sh

**Solution:**
```bash
# Make script executable
chmod +x scripts/install.sh
# Then run it
bash scripts/install.sh
```

### Issue: Symlinks not created

**On macOS/Linux:**
```bash
# Check if dotfiles directory exists
ls -la ~/dotfiles

# Manually create symlink
ln -sf ~/dotfiles/config/nvim/init.lua ~/.config/nvim/init.lua
```

**On Windows (WSL2):**
```powershell
# Run PowerShell as Administrator
# Then try install-windows.ps1 again
```

### Issue: WezTerm not found on PATH

**macOS:**
```bash
# Verify wezterm is installed
brew list wezterm

# Check PATH
echo $PATH | grep wezterm
```

**Windows:**
```powershell
# Check if wezterm is in PATH
where wezterm

# If not, add to PATH manually or reinstall
```

### Issue: Zsh not set as default shell

```bash
# Check current shell
echo $SHELL

# Change to zsh
chsh -s /bin/zsh  # macOS
chsh -s /usr/bin/zsh  # Linux/WSL2
```

---

## Next Steps

After successful installation:

1. Read the [Architecture Guide](ARCHITECTURE.md) to understand how everything integrates
2. Customize your configuration with the example files
3. Check platform-specific guides:
   - [macOS Setup Details](MACOS_SETUP.md)
   - [Windows/WSL2 Setup Details](WINDOWS_SETUP.md)
4. Review [Troubleshooting Guide](TROUBLESHOOTING.md) for common issues

---

## File Locations Reference

### Configuration Files
- **Neovim**: `~/.config/nvim/init.lua`
- **WezTerm**: `~/.config/wezterm/wezterm.lua`
- **Oh-My-Posh Theme**: `~/.config/oh-my-posh/catppuccin.omp.json`
- **Zsh**: `~/.zshrc`

### Machine-Specific Files (Gitignored)
- **Local WezTerm**: `~/.config/wezterm/.wezterm-local.lua`
- **Local Zsh**: `~/.zshrc.local`
- **Local Neovim**: `~/.config/nvim/init.local.lua`

### Examples
- See `.wezterm-local.lua.example` in the dotfiles root
- See `config/zsh/.zshrc.local.example` in the dotfiles repo

---

## Getting Help

If you encounter issues not covered in this guide:

1. Check [Troubleshooting Guide](TROUBLESHOOTING.md)
2. Review [Architecture Guide](ARCHITECTURE.md) to understand the system
3. Check the [GitHub Issues](https://github.com/visualbam/dotfiles/issues)
