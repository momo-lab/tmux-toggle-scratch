#! /usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DEFAULT_SESSION_KEY_FORMAT="#S-#I@scratch"

KEYS=$(tmux display-message -pF "#{?@toggle-scratch-keys,#{@toggle-scratch-keys},C-s}")
for key in $KEYS; do
  tmux bind-key -N 'Toggle scratch popup' $key \
    "if-shell -F '#{E:@__toggle-scratch-session-name}' \
      'detach-client' \
      'run-shell \"$CURRENT_DIR/scripts/toggle-scratch.bash $DEFAULT_SESSION_KEY_FORMAT\"' \
    "
done

tmux set-hook -g 'pane-exited' "run-shell $CURRENT_DIR/scripts/prune-popup-session.bash $DEFAULT_SESSION_KEY_FORMAT"
