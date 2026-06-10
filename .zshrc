# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ---- Custom PATH exports (restored from backup) ----
export PATH="/usr/local/opt/postgresql@15/bin:$PATH"

# ---- Fly.io setup ----
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

. "$HOME/.local/bin/env"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# bun completions
[ -s "/Users/sasha/.bun/_bun" ] && source "/Users/sasha/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Added by Antigravity
export PATH="/Users/sasha/.antigravity/antigravity/bin:$PATH"

# ---- dotfiles bin ----
export PATH="$HOME/bin:$PATH"
alias tw='tmux-sessionizer'

# Re-attach to the work session. After a reboot/crash the tmux server is dead,
# so start it first (which lets tmux-continuum auto-restore the saved state),
# wait briefly for the 'work' session to come back, then attach with -CC.
unalias twa 2>/dev/null   # tolerate an old alias lingering in the current shell
twa() {
    if tmux has-session -t work 2>/dev/null; then
        tmux -CC attach -t work
    else
        echo "No 'work' session running. Restore with: twr   (or start: tw <worktree>)"
    fi
}

# Restore tabs after a reboot/crash: rebuild every previously-open worktree as
# a window (fresh 3-pane layouts at the right dirs), then attach once. Reuses
# the working `tw` path and builds everything BEFORE the -CC attach.
unalias twr 2>/dev/null
twr() {
    if tmux has-session -t work 2>/dev/null; then
        tmux -CC attach -t work
        return
    fi
    local state_file="$HOME/.local/state/tw/worktrees"
    if [[ ! -s "$state_file" ]]; then
        echo "No saved worktrees to restore. Start one with: tw <worktree>"
        return
    fi
    # Snapshot the list first — tmux-sessionizer rewrites this file as it builds
    # each window, so reading from it directly would truncate the loop.
    local worktrees wt
    worktrees=$(cat "$state_file")
    while IFS= read -r wt; do
        [[ -n "$wt" && -d "$wt" ]] || continue
        TW_NO_ATTACH=1 tmux-sessionizer "$wt"
    done <<< "$worktrees"
    if tmux has-session -t work 2>/dev/null; then
        tmux -CC attach -t work
    else
        echo "Nothing restored (saved paths missing?). Start one with: tw <worktree>"
    fi
}

# sw (search workspace) — like `tw`, but for cmux instead of tmux. fzf-pick a
# worktree from the SAME list (worktree-candidates), then open it as a NEW cmux
# workspace with a 3-pane layout (left column split in two, full-height pane on
# the right):
#   +--------+--------+
#   | pane 1 |        |
#   +--------+ pane 3 |
#   | pane 2 |        |
#   +--------+--------+
# Run inside a cmux terminal — it drives cmux over its control socket.
unalias sw 2>/dev/null
sw() {
    local cmux selected layout out
    cmux=/Applications/cmux.app/Contents/Resources/bin/cmux
    [[ -x "$cmux" ]] || cmux=cmux            # fall back to PATH inside cmux

    selected=$(worktree-candidates | fzf) || return
    [[ -n "$selected" ]] || return

    # Build the whole layout in one shot via cmux's documented layout JSON: a
    # horizontal split (left column | full-height right) whose left column is
    # split vertically into two. All three are plain terminals rooted at --cwd.
    layout='{"direction":"horizontal","split":0.5,"children":[{"direction":"vertical","children":[{"pane":{"surfaces":[{"type":"terminal"}]}},{"pane":{"surfaces":[{"type":"terminal"}]}}]},{"pane":{"surfaces":[{"type":"terminal"}]}}]}'

    if ! out=$("$cmux" new-workspace --cwd "$selected" --name "${selected:t}" --layout "$layout" --focus true 2>&1); then
        print -ru2 -- "sw: cmux new-workspace failed (run sw inside a cmux terminal):"
        print -ru2 -- "$out"
        return 1
    fi
}

# Ctrl-F from any shell prompt → tmux-sessionizer picker
bindkey -s '^f' '^utw\n'

# Land new tmux panes/tabs in the CURRENT window's worktree root. Each worktree
# window records its own root in the @worktree-root option (set per-window by
# tmux-sessionizer), so a fresh pane resolves to *its* tab's worktree rather
# than one session-wide default. Only fires when the shell would otherwise
# start in $HOME (a new iTerm pane/tab via Cmd+D / Cmd+T), so it never fights an
# intentional cd. show-options -w resolves the calling pane's own window.
if [[ -n "$TMUX" && "$PWD" = "$HOME" ]]; then
    _tw_root=$(tmux show-options -wqv @worktree-root 2>/dev/null)
    if [[ -n "$_tw_root" && -d "$_tw_root" ]]; then
        cd "$_tw_root"
    fi
    unset _tw_root
fi

# ---- AI CLI shortcuts (permission prompts skipped — use with care) ----
alias c='claude --dangerously-skip-permissions'
alias cc='claude --continue --dangerously-skip-permissions'
alias co='codex --yolo'
alias coc='codex resume --last --yolo'

# ---- Recover from a vanished cwd (e.g. external volume ejected) ----
# Runs before each prompt: if $PWD no longer exists, bounce to home and warn.
autoload -Uz add-zsh-hook
_recover_cwd() {
    if [[ ! -d "$PWD" ]]; then
        local stale="$PWD"
        cd ~
        print -P "%F{yellow}⚠%f cwd was gone ($stale) — bounced to ~"
    fi
}
add-zsh-hook precmd _recover_cwd

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
