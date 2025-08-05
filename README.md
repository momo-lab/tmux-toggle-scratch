# tmux-toggle-scratch

A tmux plugin that provides a convenient way to toggle a scratch popup window for quick note-taking
and temporary work.

## Features

- Toggle scratch popup window with a simple key binding
- Persistent session that survives popup close/open
- Automatic session cleanup when all matching panes are closed
- Customizable key bindings and popup options
- Configurable session scope (per-window, per-session, per-pane, or global)

## Installation

### Using [TPM](https://github.com/tmux-plugins/tpm) (Tmux Plugin Manager)

Add this line to your `~/.tmux.conf`:

```bash
set -g @plugin 'momo-lab/tmux-toggle-scratch'
```

Then press `prefix + I` to install the plugin.

### Manual Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/momo-lab/tmux-toggle-scratch ~/.tmux/plugins/tmux-toggle-scratch
   ```

2. Add this line to your `~/.tmux.conf`:

   ```bash
   run-shell ~/.tmux/plugins/tmux-toggle-scratch/tmux-toggle-scratch.tmux
   ```

3. Reload tmux configuration:
   ```bash
   tmux source-file ~/.tmux.conf
   ```

## Usage

Default key binding: `prefix + Ctrl-s`

Press the key binding to:

- Open scratch popup if not currently in one
- Close scratch popup if currently inside one

The scratch session persists between toggles, so your work is never lost.

## Configuration

### Custom Key Bindings

```bash
# One key (will be prefix + C-a)
set -g @toggle-scratch-keys 'C-a'

# Multiple keys (will be prefix + C-s, prefix + C-a, prefix + M-s)
set -g @toggle-scratch-keys 'C-s C-a M-s'
```

### Custom Session Name Format

The session name format determines the scope of your scratch sessions:

```bash
# Default: "#S-#I@scratch" - separate scratch session per window
# Each window in each session gets its own scratch session

# Per-session scope - one scratch session per tmux session
set -g @toggle-scratch-session-name-format "#S@scratch"

# Per-pane scope - separate scratch session for each pane
set -g @toggle-scratch-session-name-format "#S-#I-#P@scratch"

# Global scope - single scratch session shared across all sessions/windows
set -g @toggle-scratch-session-name-format "scratch"
```

**Important**: The session name format is used for automatic cleanup detection. Include a unique
identifier (like `@scratch` in the default) to distinguish scratch sessions from regular sessions.

### Custom Popup Options

Pass additional options to `display-popup` command. You can customize popup size, position, and
appearance:

```bash
# Customize popup size and position
set -g @toggle-scratch-popup-options '-w80% -h80% -x10% -y10%'

# More examples
set -g @toggle-scratch-popup-options '-w90% -h90% -S fg=yellow,bg=black'
```

**Note**: Do not include `-E` (exit immediately) or command arguments in these options, as they are
managed by the plugin internally.

## How It Works

1. **Session Management**: Creates a unique session name based on current session and window
2. **Popup Toggle**: Uses tmux's `display-popup` to show/hide the scratch terminal
3. **Automatic Cleanup**: Monitors pane exits and removes unused scratch sessions when all matching
   panes are closed
4. **Persistence**: The scratch session continues running even when popup is closed

### Automatic Session Cleanup

Scratch sessions are automatically destroyed when all panes matching the session name format are
closed. For example:
- With format `#S-#I@scratch`: scratch session is destroyed when the corresponding window is closed
- With format `#S@scratch`: scratch session is destroyed when the entire tmux session is closed  
- With format `#S-#I-#P@scratch`: scratch session is destroyed when the specific pane is closed

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Issues and pull requests are welcome on GitHub at https://github.com/momo-lab/tmux-toggle-scratch.