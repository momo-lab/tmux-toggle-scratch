#! /usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helper.bash"

NAME=$(tmux display-message -pF "$(get_session_name_format)")
OPTS=$(tmux show-options -gvq @toggle-scratch-popup-options)
tmux display-popup $OPTS -E "tmux new-session -A -s \"$NAME\" -c \"#{pane_current_path}\" \; \
  set-option @__toggle-scratch-session-name \"$NAME\" "
