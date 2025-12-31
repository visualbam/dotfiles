# macOS Setup Guide

Detailed setup guide for macOS, covering installation, configuration, and troubleshooting.

## System Requirements

- macOS 10.13 (High Sierra) or later
- 500 MB free disk space
- Administrator access (for Homebrew installation)

## Installation Overview

The macOS setup uses Homebrew for package management and automatically installs all required dependencies.

### Packages Installed

- **neovim** - Text editor
- **zsh** - Shell with oh-my-posh integration
- **oh-my-posh** - Cross-platform prompt generator
- **fnm** - Fast Node version manager
- **wezterm** - GPU-accelerated terminal emulator
- **git** - Version control
- **lazygit** - TUI for git

## Installation Steps

### 1. Initial Setup

```bash
git clone https://github.com/visualbam/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash scripts/install.sh
```

The script will:
1. Check and install Homebrew if needed
2. Install all required packages via Homebrew
3. Create symlinks to configuration files
4. Set zsh as your default shell

### 2. Verify Installation

```bash
# Verify symlinks
ls -la ~/.config/nvim/init.lua
ls -la ~/.config/wezterm/wezterm.lua
ls -la ~/.zshrc
ls -la ~/.local/bin/wezterm

# Verify installed packages
brew list | grep neovim
brew list | grep wezterm
brew list | grep oh-my-posh

# Check current shell
echo $SHELL
# Should show: /usr/local/bin/zsh or /opt/homebrew/bin/zsh (M1/M2)
```

### 3. Final Steps

Restart your terminal to apply all changes:

```bash
# Close Terminal.app or iTerm2 and reopen
# Or run:
exec zsh
```

## macOS-Specific Configuration

### Setting Default Shell

If zsh is not your default shell after installation:

```bash
# Get path to homebrew zsh
which zsh

# Change default shell (replace with actual path from above)
chsh -s /usr/local/bin/zsh
# For M1/M2:
chsh -s /opt/homebrew/bin/zsh
```

### Setting WezTerm as Default Terminal

To make WezTerm open by default instead of Terminal.app:

1. Open **System Preferences** → **General** → **Default web browser** (in Ventura+) or **Dock & Menu Bar**
2. Install and use **SetDefaultApp** utility (third-party tool)
3. Or manually configure through Application Preferences

### Intel vs Apple Silicon

The installation works identically on both:

- **Intel Macs**: Homebrew installs to `/usr/local/bin`
- **Apple Silicon (M1/M2/M3)**: Homebrew installs to `/opt/homebrew/bin`

The scripts automatically detect and handle both architectures.

### Customizing Homebrew Installation

If you want different packages or versions:

```bash
# Edit setup-macos.sh before running install.sh
vim scripts/setup-macos.sh

# Modify the PACKAGES array to add/remove packages
```

## Node.js Setup

The installation includes fnm (Fast Node Version Manager):

```bash
# List available Node versions
fnm list-remote

# Install specific version
fnm install 18
fnm install 20

# Use specific version
fnm use 18

# Set default version
fnm default 18

# Check current version
node --version
npm --version
```

## WezTerm Configuration

### Configuring Workspaces

Create a `~/.config/wezterm/.wezterm-local.lua` file to define your custom workspaces:

```lua
-- ~/.config/wezterm/.wezterm-local.lua
local wezterm = require 'wezterm'

return {
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

### Custom Keybindings

To add macOS-specific keybindings, edit `~/.config/wezterm/.wezterm-local.lua`:

```lua
return {
  keys = {
    -- Add custom keybindings here
    { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentPane { confirm = true } },
  }
}
```

## Neovim Configuration

### Installing Additional Plugins

Edit `~/.config/nvim/init.lua` to add new plugins via lazy.nvim:

```lua
-- Add to the plugins table in init.lua
{
  'plugin/author',
  config = function()
    -- Setup code
  end
}
```

### Creating Machine-Specific Overrides

Create `~/.config/nvim/init.local.lua` for macOS-specific settings:

```lua
-- ~/.config/nvim/init.local.lua
-- This file is gitignored and loaded after init.lua

-- Example: Override colorscheme for macOS
vim.cmd.colorscheme "tokyonight"

-- Example: Custom keybindings
local keymap = vim.keymap.set
keymap("n", "<leader>w", ":w<CR>", { noremap = true })
```

## Oh-My-Posh Theme

### Viewing Available Themes

```bash
# List all available themes
oh-my-posh config list

# Check current theme
cat ~/.config/oh-my-posh/catppuccin.omp.json | grep name
```

### Creating Custom Theme

Copy the default theme and modify:

```bash
# Copy to custom theme
cp ~/.config/oh-my-posh/catppuccin.omp.json ~/.config/oh-my-posh/custom.omp.json

# Edit the theme
vim ~/.config/oh-my-posh/custom.omp.json

# Update .zshrc to use custom theme
# Change: eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/catppuccin.omp.json)"
# To:     eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/custom.omp.json)"
```

## Terminal Features

### Multi-Pane Navigation

- `Ctrl+h/j/k/l` - Navigate between panes (works in nvim or terminal)
- `Alt+h/j/k/l` - Resize panes
- `Ctrl+a |` - Split horizontally
- `Ctrl+a -` - Split vertically
- `Ctrl+a c` - Close pane

### Smart Split Detection

The configuration automatically detects if you're in Neovim or a terminal pane and routes navigation keys appropriately.

## Troubleshooting macOS

### Issue: Homebrew Installation Fails

**Problem**: `brew` command not found or installation hangs

**Solution**:
```bash
# Check Homebrew status
brew doctor

# If needed, reinstall Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then run dotfiles installation again
cd ~/dotfiles && bash scripts/install.sh
```

### Issue: zsh: command not found for nvim, wezterm, etc.

**Problem**: Newly installed tools not in PATH

**Solution**:
```bash
# Verify installation
which nvim
which wezterm

# If not found, check Homebrew installation
brew list nvim
brew list wezterm

# Refresh shell
exec zsh

# Or add to PATH in .zshrc.local
export PATH="/usr/local/bin:$PATH"  # Intel
export PATH="/opt/homebrew/bin:$PATH"  # Apple Silicon
```

### Issue: Wrong Homebrew Path

**Problem**: Can't find Homebrew packages for M1/M2

**Solution**:
```bash
# Check your Homebrew installation
arch
# If shows: arm64, you have Apple Silicon
# If shows: i386, you have Intel

# Verify Homebrew location
which brew

# Update your .zshrc.local with correct paths
```

### Issue: Wezterm Not Starting

**Problem**: Clicking WezTerm icon does nothing

**Solution**:
```bash
# Check if wezterm is installed
brew list wezterm

# Run from terminal to see errors
wezterm

# Reinstall if needed
brew uninstall wezterm
brew install wezterm
```

### Issue: nvim Plugins Not Loading

**Problem**: Lazy.nvim not installing plugins on startup

**Solution**:
```bash
# Check lazy.nvim installation directory
ls -la ~/.local/share/nvim/

# Manual plugin installation
nvim
# Inside nvim:
:Lazy install
:Lazy sync
```

### Issue: Oh-My-Posh Theme Not Applying

**Problem**: Terminal prompt looks wrong or colors are off

**Solution**:
```bash
# Check oh-my-posh installation
which oh-my-posh
oh-my-posh --version

# Test theme
oh-my-posh init zsh --config ~/.config/oh-my-posh/catppuccin.omp.json

# Reload shell
exec zsh
```

## Performance Optimization

### WezTerm Performance

If WezTerm is slow:

```lua
-- Add to ~/.config/wezterm/.wezterm-local.lua
return {
  -- Reduce GPU usage
  front_end = "OpenGL",  -- or "Software"
  
  -- Optimize scrollback
  scrollback_lines = 3500,
  
  -- Font size and rendering
  font_size = 11.0,
}
```

### Neovim Performance

If Neovim is slow:

```bash
# Check health
nvim +checkhealth

# Profile startup time
nvim --startuptime startup.log

# View results
cat startup.log
```

## Regular Maintenance

### Update All Packages

```bash
# Update Homebrew and all packages
brew update
brew upgrade

# Update neovim plugins
nvim +Lazy! sync +qa

# Update oh-my-posh
brew upgrade oh-my-posh
```

### Clean Up Unused Packages

```bash
# Remove unused dependencies
brew autoremove

# Check for outdated packages
brew outdated
```

## Next Steps

- Read [Troubleshooting Guide](TROUBLESHOOTING.md) for common issues
- Review [Architecture Guide](ARCHITECTURE.md) to understand the system
- Customize configuration files in `~/.config/` and `~/.zshrc.local`
- Explore Neovim plugins by editing `init.lua`

## Additional Resources

- [Homebrew Documentation](https://brew.sh/)
- [WezTerm Configuration](https://wezfurlong.org/wezterm/config/index.html)
- [Neovim Documentation](https://neovim.io/doc/user/)
- [Oh-My-Posh Themes](https://ohmyposh.dev/docs/themes)
- [fnm Documentation](https://github.com/Schniz/fnm)
