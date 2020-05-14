## Common tmux commands
| Command                    | Description |
| -------------------------- | ----------- |
| `tmux ls`                  | List available sessions |
| `tmux a`                   | Attach to last session  |
| `tmux a -t <n>`            | Attach to specific session, where `<n>` is the session ID or name |
| `tmux kill-session -t <n>` | Kill a session, where `<n>` is the session ID or name |

## Copy/Paste
| OS    | Instructions |
| ----- | ------------ |
| Linux | Hold `<shift>` and select text with cursor, `<ctrl-shift-c>`, `<ctrl-shift-v>` |
| macOS | Hold `<option>` and select text with cursor, `<cmd-c>`, `<cmd-v>` |

## Common shortcuts
| Hotkey         | Description |
| -------------- | ----------- |
| `<prefix> c`   | Create a new window (appears in status bar, think tabs) |
| `<prefix> <n>` | Switch to window, where `<n>` is the window index |
| `<prefix> x`   | Kill current window |
| `<prefix> d`   | Detach tmux (exit back to normal terminal) |
| `<prefix> %`   | Create horizontal pane |
| `<prefix> "`   | Create vertical pane |
| `<prefix> t`   | Show clock |
| `<prefix> :`   | Launch tmux prompt |
| `<prefix> ?`   | List all shortcuts |
