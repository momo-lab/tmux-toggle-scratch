#! /usr/bin/env bash
DEFAULT_SESSION_NAME_FORMAT="$1"

NAME=$(tmux display-message -pF \
  "#{?@toggle-scratch-session-name-format,#{E:@toggle-scratch-session-name-format},$DEFAULT_SESSION_NAME_FORMAT}")
OPTS=$(tmux show-options -gvq @toggle-scratch-popup-options)
tmux display-popup $OPTS -E "tmux new-session -A -s \"$NAME\" -c \"#{pane_current_path}\" \; \
  set-option @__toggle-scratch-session-name \"$NAME\" "
