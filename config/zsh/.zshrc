# Load Angular CLI autocompletion.
# source <(ng completion script)
# fnm
eval "$(fnm env --use-on-cd)"
# Initialize completion system
autoload -Uz compinit
compinit
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# oh my posh
# Select theme based on catppuccin theme file written by wezterm
# Use a small retry loop in case wezterm is still writing the file (race condition)
export CATPPUCCIN_FLAVOUR="mocha"
if [ -f ~/.config/catppuccin-theme ]; then
    # Read with retry for race condition handling
    for i in 1 2 3; do
        theme_content=$(cat ~/.config/catppuccin-theme 2>/dev/null | tr -d ' \n\r')
        if [ -n "$theme_content" ]; then
            export CATPPUCCIN_FLAVOUR="$theme_content"
            break
        fi
        sleep 0.05
    done
fi

# Clear cached init scripts to ensure fresh generation with current CATPPUCCIN_FLAVOUR
rm -f ~/.cache/oh-my-posh/init.*.zsh 2>/dev/null

# Initialize oh-my-posh
eval "$(oh-my-posh init zsh --config ~/.poshthemes/catppuccin.omp.json)"

# Redefine _omp_get_prompt AFTER oh-my-posh init to override the cached version
_omp_get_prompt() {
  local type=$1
  local args=("${@[2,-1]}")
  export CATPPUCCIN_FLAVOUR="${CATPPUCCIN_FLAVOUR}" 
  /opt/homebrew/bin/oh-my-posh print $type \
    --config ~/.poshthemes/catppuccin.omp.json \
    --shell=zsh \
    --shell-version=$ZSH_VERSION \
    --status=$_omp_status \
    --pipestatus="${_omp_pipestatus[*]}" \
    --no-status=$_omp_no_status \
    --execution-time=$_omp_execution_time \
    --job-count=$_omp_job_count \
    --stack-count=$_omp_stack_count \
    --terminal-width="${COLUMNS-0}" \
    ${args[@]}
}
# opencode
export PATH=/Users/brucemcelroy/.opencode/bin:$PATH
export PATH="/opt/homebrew/bin:$PATH"
# Add wezterm wrapper script to PATH so smart-splits can detect it
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim

# Catppuccin theme switching
catppuccin() {
    case "$1" in
        latte|frappe|macchiato|mocha)
            export CATPPUCCIN_FLAVOUR="$1"
            echo "✨ Catppuccin theme set to: $1"
            echo "   New Neovim instances will use this theme"
            ;;
        *)
            echo "Usage: catppuccin [latte|frappe|macchiato|mocha]"
            echo "Current theme: ${CATPPUCCIN_FLAVOUR:-not set}"
            ;;
    esac
}

# Function to reload Oh-my-posh prompt and update OpenCode theme (called by WezTerm theme switcher)
_reload_prompt() {
    if [ -f ~/.config/catppuccin-theme ]; then
        export CATPPUCCIN_FLAVOUR=$(cat ~/.config/catppuccin-theme | tr -d ' \n\r')
    fi
    
    # Update OpenCode theme based on Catppuccin theme
    if [ "$CATPPUCCIN_FLAVOUR" = "latte" ]; then
        _update_opencode_theme "catppuccin"
    else
        _update_opencode_theme "catppuccin-macchiato"
    fi
    
    eval "$(oh-my-posh init zsh --config ~/.poshthemes/catppuccin.omp.json)" > /dev/null 2>&1
    clear
}

# Helper function to update OpenCode config theme
_update_opencode_theme() {
    local theme="$1"
    local config_file="$HOME/.config/opencode/opencode.json"
    
    if [ -f "$config_file" ]; then
        # Use sed to update the theme field in the JSON
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS sed requires -i ''
            sed -i '' "s/\"theme\": \"[^\"]*\"/\"theme\": \"$theme\"/" "$config_file"
        else
            # Linux sed
            sed -i "s/\"theme\": \"[^\"]*\"/\"theme\": \"$theme\"/" "$config_file"
        fi
    fi
}

# Function to test Catppuccin sync
test-catppuccin() {
    echo "Current theme file: $(cat ~/.config/catppuccin-theme 2>/dev/null || echo "not set")"
    echo "Current env var: ${CATPPUCCIN_FLAVOUR:-not set}"
    echo ""
    echo "To test:"
    echo "1. Reload Wezterm config (Ctrl+Shift+R)"
    echo "2. Switch theme in Wezterm (Ctrl+Shift+T)"
    echo "3. Prompt should update instantly in the same pane"
}
