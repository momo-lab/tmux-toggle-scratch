#! /usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

KEYS=$(tmux display-message -pF "#{?@toggle-scratch-keys,#{@toggle-scratch-keys},C-s}")
for key in $KEYS; do
  tmux bind-key -N 'Toggle scratch popup' $key \
    "if-shell -F '#{E:@__toggle-scratch-session-name}' \
      'detach-client' \
      'run-shell \"$CURRENT_DIR/scripts/toggle-scratch.bash\"' \
    "
done

tmux set-hook -g 'pane-exited' "run-shell $CURRENT_DIR/scripts/cleanup-session.bash"
