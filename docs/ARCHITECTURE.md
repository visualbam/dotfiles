# Architecture Guide

This document explains how all the components work together to create a unified terminal experience across macOS and Windows/WSL2.

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        WezTerm Terminal                          │
│  (Windows native on Windows / macOS native on macOS)             │
└─────────────────────────────────────────────────────────────────┘
           ↓
┌─────────────────────────────────────────────────────────────────┐
│              Smart Pane Navigation (smart-splits)               │
│  Detects: nvim active? → Yes: pass to nvim | No: resize pane   │
└─────────────────────────────────────────────────────────────────┘
           ↓
┌─────────────────────────────────────────────────────────────────┐
│                    Zsh Shell (init context)                      │
│ - Loads oh-my-posh for prompt rendering                         │
│ - Sets up environment variables and aliases                     │
│ - Initializes plugin managers (fnm, opencode)                   │
└─────────────────────────────────────────────────────────────────┘
           ↓
┌─────────────────────────────────────────────────────────────────┐
│                    Neovim Text Editor                            │
│ - Lazy.nvim plugin manager auto-loads plugins                   │
│ - Smart-splits.nvim provides multiplexer integration            │
│ - Native LSP and treesitter for language features               │
└─────────────────────────────────────────────────────────────────┘
```

## Component Details

### 1. WezTerm (Terminal Emulator)

**Role**: Provides the terminal window and pane management

**Key Files**:
- `config/wezterm/wezterm.lua` - Main configuration
- `~/.config/wezterm/.wezterm-local.lua` - Machine-specific overrides (gitignored)

**How it Works**:
1. Reads `wezterm.lua` configuration on startup
2. Optionally loads `.wezterm-local.lua` for machine-specific settings
3. Sets up keybindings for pane navigation (`Ctrl+hjkl`) and resizing (`Alt+hjkl`)
4. Implements smart callbacks that check if nvim is running
5. Routes navigation to nvim or terminal panes accordingly

**macOS vs Windows**:
- **macOS**: Native WezTerm application
- **Windows**: Native WezTerm connecting to WSL2 Ubuntu domain

### 2. Smart-Splits Integration

**Role**: Unified navigation across terminal panes and nvim splits

**Mechanism**:
```lua
-- WezTerm detects Ctrl+h/j/k/l
if nvim_is_active then
  send_to_nvim(key)           -- Pass to nvim's smart-splits
else
  select_pane(direction)       -- Navigate terminal panes
end
```

**Key Features**:
- Seamless switching between nvim splits and terminal panes
- Works with multiplexer-aware navigation
- Detects nvim using `wezterm ssh_domains` API
- Fallback to terminal navigation if nvim not detected

**Configuration**:
- Defined in `wezterm.lua` using callback functions
- Respects `WEZTERM_MUXSERVER` environment variable
- Compatible with multiplexer integration in nvim init.lua

### 3. Neovim (Editor)

**Role**: Text editor with plugin ecosystem

**Key Files**:
- `config/nvim/init.lua` - Main Neovim configuration
- `~/.config/nvim/init.local.lua` - Machine-specific overrides (gitignored)

**Plugin Manager**: Lazy.nvim
- Auto-installs on first run
- Lazy-loads plugins on demand
- Manages plugin updates

**Key Plugins**:
- `smart-splits.nvim` - Multiplexer-aware navigation
- `neo-tree.nvim` - File explorer
- `telescope.nvim` - Fuzzy finder
- `nvim-lspconfig` - Language server integration
- `treesitter` - Syntax highlighting
- And many more...

**Smart-Splits Integration**:
```lua
-- In nvim init.lua
require('smart-splits').setup({
  multiplexer_integration = 'wezterm',  -- Tell it we're using wezterm
  wezterm_executable = '/Applications/WezTerm.app/Contents/MacOS/wezterm'
})
```

This allows nvim to communicate with WezTerm for seamless pane navigation.

### 4. Zsh Shell

**Role**: Command shell and environment initialization

**Key Files**:
- `config/zsh/.zshrc` - Main shell configuration
- `~/.zshrc.local` - Machine-specific additions (gitignored)

**Initialization Sequence**:
1. Load oh-my-posh prompt
2. Set up environment variables (PATH, etc.)
3. Initialize plugin managers (fnm, opencode)
4. Load shell aliases and functions
5. Source `.zshrc.local` if it exists

**Integration Points**:
- Sets `CATPPUCCIN_FLAVOUR` environment variable for theme syncing
- Initializes fnm for Node.js version management
- Loads opencode CLI integration
- Exports paths for all installed tools

### 5. Oh-My-Posh (Prompt)

**Role**: Renders the shell prompt with theme and status

**Key Files**:
- `config/oh-my-posh/catppuccin.omp.json` - Theme configuration
- Uses `CATPPUCCIN_FLAVOUR` env var for color switching

**Features**:
- Shows current directory, git branch, and status
- Displays OS and system information
- Responsive to terminal color changes
- Supports dynamic color themes

**Theme Switching**:
```bash
catppuccin mocha      # Switches CATPPUCCIN_FLAVOUR
catppuccin latte      # And reloads the prompt
```

## Cross-Platform Differences

### macOS

```
WezTerm (native macOS) 
  ↓
config/wezterm/wezterm.lua → /Applications/WezTerm.app/
  ↓
Zsh (from Homebrew)
  ↓
Neovim (from Homebrew) + nvim configs
```

**Key Points**:
- All tools installed via Homebrew
- WezTerm executable hardcoded: `/Applications/WezTerm.app/Contents/MacOS/wezterm`
- Symlinks point to Homebrew installation directories
- Native macOS environment, no virtualization

### Windows with WSL2

```
WezTerm (native Windows)
  ↓
wezterm.lua (Windows AppData)
  ↓
WSL2 Ubuntu Domain
  ├─ config/zsh/.zshrc (symlink in ~/dotfiles)
  ├─ config/nvim/init.lua (symlink in ~/dotfiles)
  └─ Zsh + Neovim (Ubuntu packages)
```

**Key Points**:
- WezTerm runs on Windows, connects to WSL2
- All CLI tools run inside WSL2 (Ubuntu)
- Symlinks created inside WSL2 filesystem
- WezTerm config on Windows, shell config in WSL2
- Shared dotfiles repository accessible from both

## File Organization

### Repository Structure

```
~/dotfiles/
├── config/
│   ├── nvim/init.lua              # Shared across platforms
│   ├── wezterm/wezterm.lua        # Loaded by macOS/Windows WezTerm
│   ├── oh-my-posh/catppuccin.omp.json
│   └── zsh/.zshrc                 # Sourced by all shells
├── bin/
│   └── wezterm                    # Wrapper script (helps PATH resolution)
├── scripts/
│   ├── install.sh                 # Universal installer
│   ├── setup-macos.sh             # macOS-specific setup
│   ├── setup-wsl.sh               # WSL2-specific setup
│   └── install-windows.ps1        # Windows PowerShell installer
├── docs/
│   └── (Documentation)
├── .gitignore                     # Excludes machine-specific files
├── .wezterm-local.lua.example
└── config/zsh/.zshrc.local.example
```

### Symlink Structure

**macOS/Linux**:
```
~/.config/nvim/init.lua      → ~/dotfiles/config/nvim/init.lua
~/.config/wezterm/wezterm.lua → ~/dotfiles/config/wezterm/wezterm.lua
~/.zshrc                      → ~/dotfiles/config/zsh/.zshrc
~/.config/oh-my-posh/catppuccin.omp.json → ~/dotfiles/config/oh-my-posh/catppuccin.omp.json
~/.local/bin/wezterm          → ~/dotfiles/bin/wezterm
```

**WSL2**:
```
Same as above, but paths are relative to WSL2 home directory
```

### Machine-Specific Files (Gitignored)

```
~/.config/wezterm/.wezterm-local.lua     # Custom workspace definitions
~/.zshrc.local                            # Custom aliases, functions, env vars
~/.config/nvim/init.local.lua             # Custom nvim settings
```

These files are created from `.example` templates and allow per-machine customization without affecting shared config.

## Data Flow Examples

### Example 1: Navigation in Nvim Split

```
User presses: Ctrl+h
       ↓
WezTerm receives key
       ↓
Smart-splits callback checks: "Is nvim active?"
       ↓ YES
Send key to nvim via wezterm API
       ↓
Nvim smart-splits plugin processes
       ↓
Nvim moves cursor to left split
```

### Example 2: Resizing Terminal Pane

```
User presses: Alt+j
       ↓
WezTerm receives key
       ↓
Smart callback checks: "Is nvim active?"
       ↓ NO
Resize terminal pane downward
       ↓
Terminal pane expands
```

### Example 3: Starting Fresh on New Machine

```
git clone ~/dotfiles
       ↓
bash scripts/install.sh
       ↓
Check OS (macOS vs Linux/WSL2)
       ↓
Create symlinks (~/.config, ~/.zshrc, etc)
       ↓
Run platform-specific setup (install packages)
       ↓
Create example config files
       ↓
User customizes .local files
       ↓
Ready to use!
```

## Integration with External Tools

### OpenCode CLI

Integrated in `.zshrc` to provide AI coding assistance directly in terminal:

```bash
# Initialize opencode
eval "$(opencode shell:init)"

# Now can use opencode commands in shell
opencode chat "explain this function"
```

### Lazy Git

Keybinding in WezTerm:

```lua
-- Press Ctrl+a g to open lazygit
action.SpawnCommandInNewWindow { args = { 'lazygit' } }
```

Allows quick git operations without leaving terminal.

### fnm (Node Version Manager)

Initialized in `.zshrc`:

```bash
eval "$(fnm env --use-on-cd)"
```

Provides automatic Node.js version switching based on `.node-version` files.

## Customization Points

### Low-Impact Customization
- Edit `.wezterm-local.lua` for workspace definitions
- Edit `.zshrc.local` for aliases and functions
- Edit `.config/nvim/init.local.lua` for nvim customizations

### Medium-Impact Customization
- Modify `config/zsh/.zshrc` for shell-wide changes
- Modify `config/nvim/init.lua` for nvim plugin changes
- Modify `config/wezterm/wezterm.lua` for WezTerm keybindings

### High-Impact Changes
- Different terminal emulator (replace WezTerm)
- Different shell (replace zsh)
- Different editor (replace nvim)
- Different OS/platform

## Performance Considerations

### Terminal Performance
- GPU acceleration in WezTerm reduces CPU usage
- Scrollback history limited to improve memory
- Pane rendering optimized for responsiveness

### Nvim Plugin Loading
- Lazy.nvim delays plugin loading until needed
- Reduces startup time significantly
- Plugins load on-demand when features used

### Shell Startup
- Oh-my-posh compiled, fast prompt rendering
- Minimal shell initialization for quick terminal opens
- Environment variables loaded once per shell session

## Security Considerations

### Gitignored Files
- `.wezterm-local.lua` - May contain machine-specific paths
- `.zshrc.local` - May contain personal aliases/functions
- `.config/nvim/init.local.lua` - Machine-specific settings

Never accidentally commit sensitive data to shared dotfiles repo.

### SSH Key Management
- SSH keys stored in `~/.ssh` (machine-specific)
- Git credentials can be shared between Windows and WSL2
- SSH agent integration for secure authentication

## Troubleshooting Architecture Issues

### Pane Navigation Not Working
1. Check: Is nvim running? (`pgrep nvim`)
2. Check: Is smart-splits installed? (`:Lazy` in nvim)
3. Check: WezTerm keybindings correct? (Check `wezterm.lua`)

### Symlinks Not Created
1. Check: Dotfiles directory exists? (`ls ~/dotfiles`)
2. Check: Permissions correct? (`ls -la ~/.config/`)
3. Check: Platform setup ran correctly? (macOS: homebrew, WSL2: apt)

### Configuration Not Loading
1. Check: Symlink points to correct file? (`ls -la ~/.zshrc`)
2. Check: File permissions? (`chmod 644 config/zsh/.zshrc`)
3. Check: Syntax errors in config? (Run shell with `bash -x`)

## Next Steps

- Read [Installation Guide](INSTALL.md) for setup instructions
- Review [Troubleshooting Guide](TROUBLESHOOTING.md) for common issues
- Check platform-specific guides:
  - [macOS Setup](MACOS_SETUP.md)
  - [Windows/WSL2 Setup](WINDOWS_SETUP.md)
