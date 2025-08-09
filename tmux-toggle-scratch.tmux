#! /usr/bin/env bash

# Check tmux version (3.2+ required for display-popup)
tmux -V | grep -q ' 3\.[2-9]\| [4-9]\.' || {
  tmux display-message "Error: tmux 3.2+ required for display-popup"
  exit 1
}

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_tmux_option() {
  local key="$1" default="$2"
  tmux display-message -pF "#{?${key},#{${key}},${default}}"
}

BIND_COMMAND="if-shell -F '#{E:@__toggle-scratch-session-name}' \\
  'detach-client' \\
  'run-shell \"$CURRENT_DIR/scripts/toggle-scratch.bash\""

for key in $(get_tmux_option @toggle-scratch-keys "C-s"); do
  tmux bind-key -N 'Toggle scratch popup' $key "$BIND_COMMAND"
done

for key in $(get_tmux_option @toggle-scratch-root-keys); do
  tmux bind-key -T root -N 'Toggle scratch popup' $key "$BIND_COMMAND"
done

tmux set-hook -g 'pane-exited' "run-shell $CURRENT_DIR/scripts/cleanup-session.bash"
