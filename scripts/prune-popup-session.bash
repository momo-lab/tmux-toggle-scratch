#! /usr/bin/env bash
# kill unused popup session

DEFAULT_SESSION_NAME_FORMAT="$1"

escape_tmux_formats() {
  local text=$(cat)
  text=$(echo "$text" | sed "s/#[^{]/.*/g")
  while echo "$text" | grep -q '#{[^#{}]*}'; do
    text=$(echo "$text" | sed "s/#{[^#{}]*}/.*/g")
  done
  echo $text
}

FORMAT=$(tmux display-message -pF \
  "#{?@toggle-scratch--name-format,#{@toggle-scratch-session-name-format},#{l:${DEFAULT_SESSION_NAME_FORMAT}}}")
PATTERN=$(echo "$FORMAT" | sed -e 's/[][)(\\.*^$+?|]/\\&/g' | escape_tmux_formats)

diff --old-line-format='' --unchanged-line-format='' --new-line-format='%L' \
  <(tmux list-panes -aF "$FORMAT" | uniq) \
  <(tmux list-sessions -F '#S' -f "#{m/r:${PATTERN},#S}") |
  xargs -I {} tmux kill-session -t {}
