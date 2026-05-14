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

# Link bin/ scripts into ~/bin
if [ -d "$DOTFILES_DIR/bin" ]; then
    mkdir -p "$HOME/bin"
    for script in "$DOTFILES_DIR/bin"/*; do
        [ -f "$script" ] || continue
        chmod +x "$script"
        create_symlink "$script" "$HOME/bin/$(basename "$script")"
    done
fi

echo ""
echo "Dotfiles installed successfully!"
echo "Restart your terminal or run 'source ~/.zshrc' to apply changes."
