#! /usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helper.bash"

NAME=$(tmux display-message -pF "$(option_session_name_format)")
tmux display-popup $(option_popup_options) -E \
  "tmux new-session -A -s \"$NAME\" -c \"#{pane_current_path}\" \; \
  set-option @__toggle-scratch-session-name \"$NAME\" "
