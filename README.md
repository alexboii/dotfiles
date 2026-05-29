# dotfiles

My personal dotfiles for macOS.

## What's included

- `.zshrc` — Zsh + Oh My Zsh + Powerlevel10k. Worktree workflow (`tw`/`twa`/`twr`/`sw`), AI CLI aliases (`c`/`cc` = claude, `co`/`coc` = codex), and a cwd-recovery hook (bounces to `~` if the current dir is unmounted).
- `.p10k.zsh` — Powerlevel10k theme.
- `.tmux.conf` — tmux config (Ctrl-A prefix, mouse, worktree-aware splits) for the iTerm `-CC` tab workflow.
- `.gitconfig` — git config (delta pager, difftastic aliases).
- `.aerospace.toml` — AeroSpace window manager.
- `ghostty/config.ghostty` — Ghostty / cmux terminal config (MesloLGS NF font, Catppuccin auto light/dark, etc.).
- `lazygit/config.yml` — lazygit config.
- `bin/` — scripts symlinked into `~/bin`:
  - `tmux-sessionizer` — backs `tw`: fzf-pick a worktree, open it as a tmux window with a 3-pane layout.
  - `worktree-candidates` — the shared worktree lister behind `tw` **and** `sw`. **Edit the search roots here, in one place.**
  - `agent-notify` — notification sound + tab flash, wired into Claude/Codex Stop hooks.
- `sounds/`, `raycast/` — assets used by the above (notification sound, Raycast scripts).

## Prerequisites

```bash
# CLI tools
brew install tmux fzf git-delta difftastic lazygit

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# MesloLGS Nerd Font (Powerlevel10k glyphs; also the Ghostty config's font)
brew install --cask font-meslo-lg-nerd-font

# AeroSpace
brew install --cask nikitabobko/tap/aerospace
```

## Install / reinstall

On a fresh machine, or to re-apply after editing the repo:

```bash
git clone https://github.com/alexboii/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` is safe to re-run — it backs up any real file it would replace (to `*.backup`), skips files that are already symlinks, then links:

| Source | Linked to |
|---|---|
| `.zshrc`, `.p10k.zsh`, `.aerospace.toml`, `.tmux.conf`, `.gitconfig` | `~/` |
| `lazygit/config.yml` | `~/Library/Application Support/lazygit/config.yml` |
| `ghostty/config.ghostty` | `~/.config/ghostty/config` (the path cmux / Ghostty actually read) |
| `bin/*` | `~/bin/` (added to `PATH` by `.zshrc`) |

It also sets the iTerm2 preference to open tmux (`-CC`) windows as **tabs in one window** (`OpenTmuxWindowsIn=1`).

Then restart the terminal, or `source ~/.zshrc`.

### Post-install
- **iTerm tabs:** `install.sh` writes the pref, but iTerm rewrites its plist on quit and can clobber a live write. If tmux windows still open as separate windows, set it in the GUI — **Settings → General → tmux → "Open tmux windows as" → Native tabs in a new window** — then detach (`tmux detach`) and `twa`.
- **cmux:** run `cmux reload-config` to pick up the Ghostty config (`cmux config doctor` to confirm it's read).
- Run `p10k configure` to re-tune the prompt if desired.

## Worktree workflow (`tw` / `sw`)

Search roots are defined once in `bin/worktree-candidates` (currently `~/wt` and `/Volumes/PRO-G40`; any dir with a `.git` within 4 levels). Both pickers fuzzy-search that same list:

- **`tw [worktree | main | path]`** — open a worktree as a tmux *window* in the single `work` session, with a 3-pane layout (two stacked left, full-height right), attached via `tmux -CC` so each window shows as an iTerm tab. Bare `tw` opens the fzf picker; `Ctrl-F` at the prompt also launches it.
- **`twa`** — reattach to the running `work` session.
- **`sw`** — same picker, but opens the worktree as a **cmux** workspace with the same 3-pane layout. Run it inside a cmux terminal (it drives cmux over its control socket).

## Restore after a reboot / crash

The tmux server doesn't survive a reboot. Every `tw` run records the open worktrees to `~/.local/state/tw/worktrees`, so the session can be rebuilt:

```bash
twr     # rebuild 'work': replays each saved worktree as a 3-pane tab, then attaches via -CC
twa     # if the work session is somehow still alive, just reattach
```

Notes:
- `twr` needs each worktree's filesystem mounted. If they live on an external volume (e.g. `/Volumes/PRO-G40`), **mount it first** or those tabs are skipped with a warning.
- Persistence is intentionally just the worktree-path list — there is **no** tmux-resurrect/continuum (they fight iTerm `-CC`). Running processes and pane contents are not restored; resume agents with `claude --continue` / `codex resume` inside each worktree.
```

