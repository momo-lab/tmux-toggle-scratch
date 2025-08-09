#! /usr/bin/env bash

# Check tmux version (3.2+ required for display-popup)
tmux -V | grep -q ' 3\.[2-9]\| [4-9]\.' || {
  tmux display-message "Error: tmux 3.2+ required for display-popup"
  exit 1
}

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helper.bash"

BIND_COMMAND="if-shell -F '#{E:@__toggle-scratch-session-name}' \\
  'detach-client' \\
  'run-shell \"$CURRENT_DIR/scripts/show-scratch-popup.bash\"'"

for key in $(option_keys); do
  tmux bind-key -N 'Toggle scratch popup' $key "$BIND_COMMAND"
done

for key in $(option_root_keys); do
  tmux bind-key -T root -N 'Toggle scratch popup' $key "$BIND_COMMAND"
done

tmux set-hook -g 'pane-exited' "run-shell $CURRENT_DIR/scripts/cleanup-session.bash"
