#! /usr/bin/env bash
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$current_dir/helper.bash"

name=$(tmux display-message -pF "$(option_session_name_format)")
tmux display-popup $(option_popup_options) -E \
  "tmux new-session -A -s \"$name\" -c \"#{pane_current_path}\" \; \
  set-option @__toggle-scratch-session-name \"$name\" "
