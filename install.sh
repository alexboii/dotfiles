#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles from $DOTFILES_DIR"

# Backup existing files
backup_file() {
    if [ -f "$1" ] && [ ! -L "$1" ]; then
        echo "Backing up $1 to $1.backup"
        mv "$1" "$1.backup"
    fi
}

# Create symlinks
create_symlink() {
    local src="$1"
    local dest="$2"

    backup_file "$dest"

    if [ -L "$dest" ]; then
        rm "$dest"
    fi

    ln -sf "$src" "$dest"
    echo "Linked $src -> $dest"
}

create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
create_symlink "$DOTFILES_DIR/.aerospace.toml" "$HOME/.aerospace.toml"
create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# lazygit config (macOS stores it under Application Support)
mkdir -p "$HOME/Library/Application Support/lazygit"
create_symlink "$DOTFILES_DIR/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"

# ghostty config — cmux reads ~/.config/ghostty/config for terminal behavior
# (font, theme, transparency, blur). cmux only reads it, so a symlink is safe.
mkdir -p "$HOME/.config/ghostty"
create_symlink "$DOTFILES_DIR/ghostty/config.ghostty" "$HOME/.config/ghostty/config"

# Link bin/ scripts into ~/bin
if [ -d "$DOTFILES_DIR/bin" ]; then
    mkdir -p "$HOME/bin"
    for script in "$DOTFILES_DIR/bin"/*; do
        [ -f "$script" ] || continue
        chmod +x "$script"
        create_symlink "$script" "$HOME/bin/$(basename "$script")"
    done
fi

# ---- iTerm2 tmux integration ----
# Open tmux (-CC) windows as native tabs in a single window instead of as
# separate windows. Values: 0=native windows, 1=native tabs in a new window,
# 2=tabs in existing window. Quit iTerm first (it rewrites its prefs on exit);
# the change takes effect on next launch.
if [ -d "/Applications/iTerm.app" ]; then
    defaults write com.googlecode.iterm2 OpenTmuxWindowsIn -int 1
    echo "Set iTerm2 to open tmux windows as tabs (OpenTmuxWindowsIn=1)"
fi

echo ""
echo "Dotfiles installed successfully!"
echo "Restart your terminal or run 'source ~/.zshrc' to apply changes."
