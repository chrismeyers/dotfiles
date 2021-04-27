## Common tmux commands
| Command                    | Description |
| -------------------------- | ----------- |
| `tmux ls`                  | List available sessions |
| `tmux a`                   | Attach to last session  |
| `tmux a -t <n>`            | Attach to specific session, where `<n>` is the session ID or name |
| `tmux kill-session -t <n>` | Kill a session, where `<n>` is the session ID or name |
| `tmux kill-server`         | Resets all current sessions |

## Copy/Paste
| Interface | OS    | Instructions |
| --------- | ----- | ------------ |
| Mouse     | Linux | Hold `<shift>` and select text with cursor, `<ctrl-shift-c>` to copy, `<ctrl-shift-v>` to paste |
|           | macOS | Hold `<option>` and select text with cursor, `<cmd-c>` to copy, `<cmd-v>` to paste |
| Keyboard  | N/A   | Press `<prefix> C-[` to enter copy mode, `hjkl` or `<arrow>` to navigate, `v` for free-form selection, `V` to select the entire line, `r` to toggle rectangle selection, `y` to copy selected text, `q` to exit copy mode, `<prefix> C-]` to paste |

## Common shortcuts
| Hotkey               | Description |
| -------------------- | ----------- |
| `<prefix> c`         | Create a new window (appears in status bar, think tabs) |
| `<prefix> <n>`       | Switch to window, where `<n>` is the window index or name |
| `<prefix> n`         | Go to the next window |
| `<prefix> p`         | Go to the previous window |
| `<prefix> x`         | Kill current window |
| `<prefix> s`         | Open window and session selection screen (`<right-arrow>` expands the selected session) |
| `<prefix> d`         | Detach tmux (exit back to normal terminal) |
| `<prefix> %`         | Create horizontal pane |
| `<prefix> "`         | Create vertical pane |
| `<prefix> !`         | Move pane to a new window |
| `<prefix> <space>`   | Cycle through `:next-layout` in current window |
| `<prefix> o`         | Cycle focus through all panes in current window |
| `<prefix> <arrow>`   | Move focus to next pane in direction of `<arrow>` |
| `<prefix> <ctrl-o>`  | Move all panes clockwise |
| `<prefix> M-<arrow>` | Resize current pane based on which `<arrow>` key was pressed |
| `<prefix> t`         | Show clock |
| `<prefix> q`         | Show pane numbers |
| `<prefix> :`         | Launch tmux prompt |
| `<prefix> ?`         | List all shortcuts |

## Common prompt commands
| Command                    | Description |
| -------------------------- | ----------- |
| `:new-session -s <n>`      | Creates a new session from within tmux with `<n>` (auto incremented number if omitted) |
| `:kill-session -t <n>`     | Kills session `<n>` |
| `:join-pane -t :<n>`       | Move pane to window `<n>` (`-v` or `-h` can be used to specify vertical or horizontal pane) |
| `:resize-p -<dir> <n>`     | Resize current pane in `<dir>` direction (`D`, `U`, `L`, `R`) `<n>` cells (`1` cell if omitted) |

## Troubleshooting
- Fix missing `tmux-256color` terminfo on macOS [[Link](https://gist.github.com/bbqtd/a4ac060d6f6b9ea6fe3aabe735aa9d95)]
- The default meta key (`M-`) is usually `<esc>` on macOS
- If the mouse is enabled it can be used to resize panes, set focus in a pane, and select a window
