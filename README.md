# dotfiles

My personal dotfiles for macOS.

## What's included

- `.zshrc` - Zsh configuration with Oh My Zsh and Powerlevel10k
- `.p10k.zsh` - Powerlevel10k theme configuration
- `.aerospace.toml` - AeroSpace window manager configuration

## Prerequisites

```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install Meslo Nerd Font (for Powerlevel10k icons)
brew install --cask font-meslo-lg-nerd-font

# Install AeroSpace
brew install --cask nikitabobko/tap/aerospace
```

## Installation

```bash
# Clone this repo
git clone https://github.com/alexboii/dotfiles.git ~/dotfiles

# Run install script
cd ~/dotfiles
./install.sh
```

## Manual Installation

```bash
# Symlink dotfiles
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/dotfiles/.aerospace.toml ~/.aerospace.toml
```

## Post-install

- Set terminal font to "MesloLGM Nerd Font Mono" in iTerm2/Cursor
- Run `p10k configure` to customize the prompt
