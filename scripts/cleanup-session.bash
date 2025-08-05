#! /usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helper.bash"

escape_tmux_formats() {
  local text=$(cat)
  text=$(echo "$text" | sed "s/#[^{]/.*/g")
  while echo "$text" | grep -q '#{[^#{}]*}'; do
    text=$(echo "$text" | sed "s/#{[^#{}]*}/.*/g")
  done
  echo $text
}

FORMAT=$(get_session_name_format)
PATTERN=$(echo "$FORMAT" | sed -e 's/[][)(\\.*^$+?|]/\\&/g' | escape_tmux_formats)
diff --old-line-format='' --unchanged-line-format='' --new-line-format='%L' \
  <(tmux list-panes -aF "$FORMAT" | uniq) \
  <(tmux list-sessions -F '#S' -f "#{m/r:${PATTERN},#S}") |
  xargs -I {} tmux kill-session -t {}
