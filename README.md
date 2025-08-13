# tmux-toggle-scratch

A tmux plugin to toggle scratch popup sessions for quick note-taking and temporary work.

## Features

- Toggle scratch popup sessions with simple key bindings
- Persistent sessions that survive popup close/open cycles
- Automatic session cleanup to remove unused scratch sessions
- Customizable key bindings and popup options
- Configurable session scope (per-window, per-session, per-pane, or global)

## Demo

https://github.com/user-attachments/assets/4c1a5518-5cb2-4bd3-a264-005a09af9880

## Requirements

- tmux 3.2 or higher (required for `display-popup` command)

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

- **Open** a scratch popup session if none is currently visible
- **Close** the scratch popup if it's already open (returns to your main work)
- **Resume** your previous scratch session exactly where you left off

The scratch session persists between toggles, so your work is never lost.

### Common Use Cases

- **Quick notes**: `prefix + Ctrl-s` → jot down ideas → `prefix + Ctrl-s` (close)
- **Temporary commands**: Check git status, run tests, or debug without disrupting your main work
- **Multi-project development**: Different scratch sessions for each project window automatically

## Configuration

### Custom Key Bindings

```bash
# One key (will be prefix + C-a)
set -g @toggle-scratch-keys 'C-a'

# Multiple keys (will be prefix + C-s, prefix + C-a, prefix + M-s)
set -g @toggle-scratch-keys 'C-s C-a M-s'
```

### Root Table Key Bindings (No Prefix)

For even faster access, you can bind keys directly to the root table (no prefix required):

```bash
# Single key without prefix (F12)
set -g @toggle-scratch-root-keys 'F12'

# Multiple keys without prefix (F12, M-s)
set -g @toggle-scratch-root-keys 'F12 M-s'
```

**Warning**: Root table bindings can conflict with system shortcuts and other applications.
Use function keys (F1-F12) or Alt combinations to minimize conflicts.

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

### Hook-based Cleanup

By default, cleanup runs when you open a scratch session. You can also enable immediate cleanup when panes/windows are closed:

```bash
# Enable tmux hooks for immediate cleanup (default: off)
set -g @toggle-scratch-use-hooks on
```

**Note**: This option uses the following tmux hooks: `pane-exited`, `after-kill-pane`, and `window-unlinked`.
If you or other plugins already use these hooks, enabling this option will **overwrite existing hooks completely** and may cause conflicts.

**Alternative approach**: If you need to integrate with existing hooks, disable this option and manually add the cleanup command to your existing hooks:

```bash
# Example: integrating with existing pane-exited hook
set -g @toggle-scratch-use-hooks off
set-hook -g 'pane-exited' 'your-existing-command ; run-shell ~/.tmux/plugins/tmux-toggle-scratch/scripts/cleanup-session.bash'
```

Replace `~/.tmux/plugins/tmux-toggle-scratch` with your actual plugin installation path.

## Automatic Session Cleanup

Scratch sessions are automatically cleaned up in the following ways:

1. **On-demand cleanup**: Runs before opening a scratch session (always enabled)
2. **Hook-based cleanup**: Runs immediately when panes/windows are closed (optional)

Cleanup removes unused scratch sessions when all panes matching the session name format are closed. For example:

- With format `#S-#I@scratch`: scratch session is destroyed when the corresponding window is closed
- With format `#S@scratch`: scratch session is destroyed when the entire tmux session is closed
- With format `#S-#I-#P@scratch`: scratch session is destroyed when the specific pane is closed

### Limitations

Scratch sessions can get lost or mixed up if you perform operations that change any of the
tmux format variables used in your session name format:

- **Session name changes** (affects `#S`) - moving windows between sessions, renaming
  sessions
- **Window index changes** (affects `#I`) - swapping windows, renumbering windows, moving
  windows within a session
- **Pane index changes** (affects `#P`) - closing other panes, swapping panes,
  splitting/joining panes

The cleanup mechanism relies on exact format matching, so changes to the underlying tmux
state can cause your scratch work to disappear or get assigned to the wrong location.

If you frequently use advanced tmux operations, consider using ID-based formats like
`"#{session_id}-#{window_id}@scratch"` which are stable across operations.

## How It Works

1. **Session Management**: Creates a unique session name based on current session and window
2. **Popup Toggle**: Uses tmux's `display-popup` to show/hide the scratch terminal
3. **Automatic Cleanup**: Removes unused scratch sessions through on-demand and optional hook-based cleanup
4. **Persistence**: The scratch session continues running even when popup is closed

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Issues and pull requests are welcome on GitHub at https://github.com/momo-lab/tmux-toggle-scratch.
