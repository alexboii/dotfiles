#!/usr/bin/env bash
#
# Raycast Script Command — launches tmux-sessionizer in a new iTerm2 tab.
# Leave the argument empty to get the fzf picker; pass a path to skip it.
#
# @raycast.schemaVersion 1
# @raycast.title tw
# @raycast.description Open a tmux workspace (3-pane layout) in iTerm2
# @raycast.mode silent
# @raycast.packageName Dev
# @raycast.icon 🌳
# @raycast.argument1 { "type": "text", "placeholder": "worktree path (optional)", "optional": true }

ROOT="${1:-}"
# Shell-escape so paths with spaces / quotes survive AppleScript interpolation
QUOTED=$(printf '%q' "$ROOT")

osascript <<APPLESCRIPT
tell application "iTerm2"
  activate
  if (count of windows) = 0 then
    create window with default profile
  else
    tell current window to create tab with default profile
  end if
  tell current session of current window
    write text "tmux-sessionizer ${QUOTED}"
  end tell
end tell
APPLESCRIPT
