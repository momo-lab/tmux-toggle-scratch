#! /usr/bin/env bash

# Check tmux version (3.2+ required for display-popup)
tmux -V | grep -q ' 3\.[2-9]\| [4-9]\.' || {
  tmux display-message "Error: tmux 3.2+ required for display-popup"
  exit 1
}

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BIND_COMMAND="if-shell -F '#{E:@__toggle-scratch-session-name}' \\
  'detach-client' \\
  'run-shell \"$CURRENT_DIR/scripts/toggle-scratch.bash\""

KEYS=$(tmux display-message -pF "#{?@toggle-scratch-keys,#{@toggle-scratch-keys},C-s}")
for key in $KEYS; do
  tmux bind-key -N 'Toggle scratch popup' $key "$BIND_COMMAND"
done

ROOT_KEYS=$(tmux display-message -pF "#{?@toggle-scratch-root-keys,#{@toggle-scratch-root-keys},}")
for key in $ROOT_KEYS; do
  tmux bind-key -T root -N 'Toggle scratch popup' $key "$BIND_COMMAND"
done

tmux set-hook -g 'pane-exited' "run-shell $CURRENT_DIR/scripts/cleanup-session.bash"
