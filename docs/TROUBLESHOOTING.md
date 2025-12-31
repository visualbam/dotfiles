# Troubleshooting Guide

Common issues and solutions for the dotfiles setup.

## Installation Issues

### Script Won't Run

**Problem**: `bash: scripts/install.sh: Permission denied`

**Solution**:
```bash
# Make script executable
chmod +x ~/dotfiles/scripts/install.sh

# Then run
bash ~/dotfiles/scripts/install.sh
```

Or explicitly use bash:
```bash
bash ~/dotfiles/scripts/install.sh
```

### PowerShell Script Execution Error (Windows)

**Problem**: `File cannot be loaded because running scripts is disabled`

**Solution**:
```powershell
# Run PowerShell as Administrator
# Then set execution policy temporarily
powershell -ExecutionPolicy Bypass -File scripts/install-windows.ps1
```

Or change policy permanently:
```powershell
# As Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Homebrew Installation Fails (macOS)

**Problem**: `brew` command not found or installation hangs

**Solution**:
```bash
# Check if Homebrew is installed
which brew

# If not, install manually
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then run dotfiles installation again
cd ~/dotfiles && bash scripts/install.sh
```

### WSL2 Not Found (Windows)

**Problem**: `wsl: command not found` or `WSL2 not installed`

**Solution**:
```powershell
# Check if WSL2 is installed
wsl --list --verbose

# If not installed, install it
wsl --install

# Restart computer
# Then complete Ubuntu setup
```

## Configuration Issues

### Symlinks Not Created

**macOS/Linux**:
```bash
# Check if symlinks were created
ls -la ~/.config/nvim/init.lua
ls -la ~/.zshrc

# If not symlinks, manually create them
ln -sf ~/dotfiles/config/nvim/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/config/zsh/.zshrc ~/.zshrc
```

**WSL2**:
```bash
# From WSL2 terminal, check symlinks
ls -la ~/.zshrc

# If symlink restrictions, edit /etc/wsl.conf
sudo nano /etc/wsl.conf

# Add or modify:
# [interop]
# appendWindowsPath = true
# [wsl2]
# kernelCommandLine = sysctl.fs.mqueue.msg_max=98304

# Restart WSL2
wsl --shutdown
wsl
```

### .zshrc Not Loading

**Problem**: Shell doesn't load `.zshrc` on startup

**Solution**:
```bash
# Check if zsh is default shell
echo $SHELL
# Should show: /bin/zsh or /usr/bin/zsh or /opt/homebrew/bin/zsh

# If not, set it
chsh -s /bin/zsh

# Then restart terminal
exec zsh
```

### Oh-My-Posh Theme Not Applying

**Problem**: Prompt looks wrong or missing elements

**Solution**:
```bash
# Check oh-my-posh is installed
which oh-my-posh

# Check theme file exists
ls -la ~/.config/oh-my-posh/catppuccin.omp.json

# Test theme manually
oh-my-posh init zsh --config ~/.config/oh-my-posh/catppuccin.omp.json

# Reload shell
exec zsh
```

### Custom Config File Not Loading

**Problem**: `.zshrc.local` or `.wezterm-local.lua` not being used

**Solution**:

For `.zshrc.local`:
```bash
# Check file exists
ls -la ~/.zshrc.local

# Check if sourced in .zshrc
grep "zshrc.local" ~/.zshrc

# If not sourced, add to .zshrc:
# [ -f ~/.zshrc.local ] && source ~/.zshrc.local
```

For `.wezterm-local.lua`:
```lua
-- Check if wezterm.lua loads it
grep "wezterm-local" ~/.config/wezterm/wezterm.lua

-- If not, add this to wezterm.lua at the end:
-- pcall(function() return require('wezterm-local') end)
```

## Tool-Specific Issues

### Neovim Problems

#### nvim Command Not Found

```bash
# Check installation
which nvim

# If not found, check homebrew (macOS)
brew list neovim

# Reinstall if needed
brew install neovim
```

#### Plugins Not Loading

```bash
# Open nvim
nvim

# Inside nvim, run:
:Lazy install
:Lazy sync

# Or from command line:
nvim +Lazy! sync +qa
```

#### Colorscheme Not Working

```bash
# Check if colorscheme plugin is installed
nvim +Lazy

# Look for colorscheme plugin in list

# If missing, add to config/nvim/init.lua and reinstall plugins
```

#### LSP Not Working

```bash
# Inside nvim:
:checkhealth nvim.lsp

# Check for missing servers
:LspInfo

# Install missing servers
:MasonInstall rust-analyzer pyright
```

### WezTerm Issues

#### WezTerm Won't Start

**macOS**:
```bash
# Check installation
which wezterm
brew list wezterm

# Try running from terminal
wezterm

# Check for errors
wezterm --help
```

**Windows**:
```powershell
# Check if wezterm is in PATH
where wezterm

# If not, reinstall
scoop uninstall wezterm
scoop install wezterm
```

#### WSL2 Domain Not Showing (Windows)

**Problem**: WezTerm opens but WSL2 domain not available

**Solution**:
```powershell
# Check WSL2 distributions
wsl --list --verbose

# Edit wezterm.lua in %APPDATA%\wezterm\
notepad $env:APPDATA\wezterm\wezterm.lua

# Ensure distribution name matches exactly:
# config.wsl_domains = {
#   { name = 'WSL:Ubuntu', distribution = 'Ubuntu' }
# }

# Restart WezTerm
```

#### Smart Navigation Not Working

**Problem**: Ctrl+hjkl doesn't navigate between panes

**Solution**:
```bash
# Check smart-splits is installed in nvim
nvim +Lazy

# Search for smart-splits

# Verify keybindings in wezterm.lua
grep -A5 "Ctrl.*h.*j.*k.*l" ~/.config/wezterm/wezterm.lua

# Test manually - open pane and press Ctrl+j
```

### Zsh Issues

#### Command Not Found

```bash
# Check PATH
echo $PATH

# Check if .zshrc is being sourced
source ~/.zshrc

# Look for tool
which nvim

# Add to PATH if needed
export PATH="/usr/local/bin:$PATH"
```

#### Aliases Not Working

```bash
# Check if .zshrc.local exists
ls -la ~/.zshrc.local

# Create if missing
cp ~/.zshrc.local.example ~/.zshrc.local

# Add alias
echo 'alias myalias="echo hello"' >> ~/.zshrc.local

# Reload
exec zsh
```

### Oh-My-Posh Issues

#### Theme Not Found

```bash
# Check theme file path
ls -la ~/.config/oh-my-posh/catppuccin.omp.json

# Check if readable
cat ~/.config/oh-my-posh/catppuccin.omp.json | head

# Reinstall theme
cp ~/dotfiles/config/oh-my-posh/catppuccin.omp.json ~/.config/oh-my-posh/catppuccin.omp.json
```

#### Colors Look Wrong

```bash
# Check terminal supports 256 colors
echo $TERM

# Should show: xterm-256color

# Test color scheme
catppuccin mocha

# If issue persists, check oh-my-posh version
oh-my-posh --version
```

### Node.js (fnm) Issues

#### fnm Not Found

```bash
# Check installation
which fnm

# If not found on macOS
brew install fnm

# Or on Linux/WSL2
curl -fsSL https://fnm.io/install | bash

# Initialize fnm
eval "$(fnm env --use-on-cd)"
```

#### Node Version Wrong

```bash
# Check current version
node --version

# List available versions
fnm list-remote

# Install correct version
fnm install 18

# Use specific version
fnm use 18

# Set as default
fnm default 18
```

## Platform-Specific Issues

### macOS-Specific

#### Homebrew Packages Not Installing

```bash
# Update Homebrew
brew update

# Check for issues
brew doctor

# Reinstall specific package
brew uninstall neovim
brew install neovim
```

#### Wrong zsh Path

```bash
# Check Homebrew zsh path
which zsh

# Intel Mac should show: /usr/local/bin/zsh
# Apple Silicon should show: /opt/homebrew/bin/zsh

# Update .zshrc if needed
chsh -s /opt/homebrew/bin/zsh  # For Apple Silicon
```

### Windows/WSL2-Specific

#### WSL2 Slow File Access

**Problem**: Reading files from `/mnt/c/` is very slow

**Solution**: Keep files in WSL2 home directory
```bash
# Good (fast)
cd ~/projects
nvim myfile.txt

# Slow
cd /mnt/c/Users/username/Projects
nvim myfile.txt
```

#### Clipboard Not Working

```bash
# Install clipboard tools
sudo apt-get install wl-clipboard

# Test
echo "test" | wl-copy
wl-paste

# Configure nvim for clipboard
# Add to ~/.config/nvim/init.local.lua:
# vim.g.clipboard = { name = 'wl-clipboard' }
```

#### SSH Keys Not Working

```bash
# Check key permissions
ls -la ~/.ssh/
# Should show: -rw------- (600) for private keys

# Fix if needed
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

# Test SSH
ssh -vv git@github.com
```

## Diagnostic Commands

### Check System Information

```bash
# Operating system
uname -a

# Shell
echo $SHELL
$SHELL --version

# Check if in WSL
grep -i microsoft /proc/version

# Available distributions (WSL2)
wsl --list --verbose
```

### Verify Tool Installation

```bash
# Check all tools
for tool in nvim zsh oh-my-posh fnm wezterm git lazygit; do
  echo -n "$tool: "
  which $tool || echo "NOT FOUND"
done
```

### Check Configuration Files

```bash
# Verify symlinks
echo "=== Symlinks ==="
ls -la ~/.zshrc
ls -la ~/.config/nvim/init.lua
ls -la ~/.config/wezterm/wezterm.lua

# Check file integrity
echo "=== File Syntax ==="
zsh -n ~/.zshrc  # Check zsh syntax
# lua -n ~/.config/wezterm/wezterm.lua  # Check lua syntax (if lua installed)
```

### Test Configurations

```bash
# Test shell startup time
time zsh -i -c exit

# Test nvim startup time
nvim --startuptime startup.log +qa
cat startup.log | tail -20

# Test wezterm
wezterm start --class TestWindow
```

## Getting More Help

### Enable Debug Logging

**Zsh**:
```bash
# Run shell with debug output
zsh -x

# Or add to .zshrc temporarily
set -x  # Enable debug
# ... problematic code ...
set +x  # Disable debug
```

**Neovim**:
```bash
# Check health
nvim +checkhealth

# Enable debug mode
export NVIM_LOG_FILE=~/nvim.log
nvim

# Check log
cat ~/nvim.log
```

**WezTerm**:
```bash
# Check version and config
wezterm ls

# Print configuration
wezterm show-keys --lua
```

### Get System Information for Debugging

```bash
# Comprehensive system info
{
  echo "=== System ==="
  uname -a
  echo "=== Shell ==="
  echo $SHELL
  echo "=== Tools ==="
  which nvim wezterm zsh oh-my-posh
  echo "=== Symlinks ==="
  ls -la ~/.zshrc
  ls -la ~/.config/nvim/init.lua
  echo "=== PATH ==="
  echo $PATH
} | tee debug-info.txt
```

## Common Error Messages

### "command not found: nvim"

**Check**:
1. Tool installed? `brew list nvim`
2. In PATH? `which nvim`
3. Shell reloaded? `exec zsh`

### "zsh: parse error: bad substitution"

**Check**:
1. Syntax error in `.zshrc`
2. Quote mismatch
3. Invalid variable expansion

**Fix**:
```bash
zsh -n ~/.zshrc  # Check syntax
```

### "ln: /Users/user/.zshrc: File exists"

**Solution**:
```bash
# Remove existing file and create symlink
rm ~/.zshrc
ln -s ~/dotfiles/config/zsh/.zshrc ~/.zshrc
```

### "permission denied" during installation

**Solution**:
```bash
# Run with explicit bash
bash ~/dotfiles/scripts/install.sh

# Or make executable
chmod +x ~/dotfiles/scripts/install.sh
bash ~/dotfiles/scripts/install.sh
```

## Performance Issues

### Terminal Slow to Start

```bash
# Measure startup time
time nvim --headless +quit

# Check for slow plugins
nvim --startuptime startup.log
cat startup.log | sort -k2 -rn | head -20
```

### WezTerm GPU Issues

If WezTerm is slow on your GPU:

```lua
-- In ~/.config/wezterm/.wezterm-local.lua
return {
  front_end = "Software",  -- Disable GPU acceleration
  scrollback_lines = 3500,
}
```

### High CPU/Memory Usage

```bash
# Monitor processes
top -o %CPU | head -10

# Kill and restart problematic process
killall nvim  # Restart nvim
exec zsh      # Restart shell
```

## When All Else Fails

1. **Check the Architecture Guide**: `docs/ARCHITECTURE.md`
2. **Review Platform Setup**: `docs/MACOS_SETUP.md` or `docs/WINDOWS_SETUP.md`
3. **Check Installation Steps**: `docs/INSTALL.md`
4. **Search GitHub Issues**: https://github.com/visualbam/dotfiles/issues
5. **Review Logs**: 
   - Nvim: `cat ~/nvim.log`
   - Wezterm: `wezterm show-config`
   - Shell: `zsh -x`

## Reporting Issues

When reporting issues, include:

1. Output of system info (see above)
2. Configuration files (if not private)
3. Error messages (exact copy)
4. Steps to reproduce
5. Expected vs actual behavior
