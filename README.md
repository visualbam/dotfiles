# Dotfiles

A unified cross-platform dotfiles setup for seamless terminal, editor, and shell configuration across macOS and Windows/WSL2.

## Features

- **Unified Keybindings**: Ctrl+hjkl for navigation, Alt+hjkl for resizing across nvim splits and terminal panes
- **Smart Terminal Navigation**: Automatic detection of nvim vs terminal panes for context-aware routing
- **Cross-Platform Support**: Works identically on macOS and Windows/WSL2
- **Theme Switching**: Catppuccin theme with dynamic color switching
- **Machine-Specific Config**: Template system for per-machine customization
- **Integrated Tools**:
  - Neovim (nvim) with lazy.nvim plugin manager
  - Helix editor with language support
  - WezTerm terminal emulator with smart pane management
  - Oh-My-Posh shell prompt with Catppuccin theme
  - Node version manager (fnm)
  - Lazy Git for git operations
  - OpenCode CLI integration

## What's Included

```
config/
├── nvim/init.lua              # Neovim configuration with smart-splits
├── helix/                      # Helix editor configuration
├── wezterm/wezterm.lua        # WezTerm terminal configuration
├── oh-my-posh/                # Oh-My-Posh theme and configuration
└── zsh/.zshrc                 # Zsh shell configuration

scripts/
├── install.sh                 # Universal installation script
├── setup-macos.sh             # macOS-specific setup
├── setup-wsl.sh               # WSL2-specific setup
└── install-windows.ps1        # Windows PowerShell installer

bin/
└── wezterm                    # WezTerm wrapper script for PATH

docs/
├── INSTALL.md                 # Detailed installation guide
├── MACOS_SETUP.md             # macOS-specific setup guide
├── WINDOWS_SETUP.md           # Windows/WSL2 setup guide
├── ARCHITECTURE.md            # How the system works
└── TROUBLESHOOTING.md         # Common issues and fixes
```

## Quick Start

### macOS

```bash
git clone https://github.com/visualbam/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash scripts/install.sh
```

### Windows (with WSL2)

```powershell
# Run PowerShell as Administrator
git clone https://github.com/visualbam/dotfiles.git %USERPROFILE%\dotfiles
cd %USERPROFILE%\dotfiles
powershell -ExecutionPolicy Bypass -File scripts/install-windows.ps1
```

## Key Keybindings

| Binding | Action | Context |
|---------|--------|---------|
| `Ctrl+h/j/k/l` | Navigate left/down/up/right | Seamless nvim ↔ pane navigation |
| `Alt+h/j/k/l` | Resize pane | Auto-detects nvim or terminal pane |
| `Ctrl+a` | WezTerm leader key | Open command palette with `Ctrl+a Ctrl+a` |

## Configuration

### Machine-Specific Customization

Each machine can have custom configuration without affecting the shared dotfiles:

- **`.wezterm-local.lua`**: Local WezTerm workspace definitions and window layouts
- **`.zshrc.local`**: Local shell aliases, functions, and environment variables
- **`.config/nvim/init.local.lua`**: Local Neovim customizations

These files are automatically gitignored, so they won't be committed to the repository.

### Theme Switching

Switch between Catppuccin color schemes:

```bash
catppuccin latte    # Light theme
catppuccin frappe   # Dark theme (default)
catppuccin macchiato # Dark theme (less contrast)
catppuccin mocha    # Dark theme (high contrast)
```

## Platform-Specific Notes

### macOS
- WezTerm opens natively
- Homebrew is used for package management
- Shell integration is automatic

### Windows with WSL2
- WezTerm opens the WSL2 Ubuntu domain by default
- Installation runs in Administrator PowerShell
- All tools run inside WSL2 (Ubuntu)
- Windows native tools are not required

## For More Information

- **[Installation Guide](docs/INSTALL.md)** - Step-by-step setup instructions
- **[macOS Setup](docs/MACOS_SETUP.md)** - macOS-specific details
- **[Windows Setup](docs/WINDOWS_SETUP.md)** - Windows/WSL2-specific details
- **[Architecture](docs/ARCHITECTURE.md)** - How everything integrates
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions

## Requirements

### macOS
- Homebrew (installed automatically if not present)
- macOS 10.13+

### Windows with WSL2
- Windows 10/11
- WSL2 with Ubuntu installed
- Administrator access for installation
- (Optional) Scoop or Winget for easy WezTerm installation

## Troubleshooting

Common issues are documented in [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

## License

MIT License - See [LICENSE.md](LICENSE.md)

## Contributing

Feel free to fork and customize for your own use!
