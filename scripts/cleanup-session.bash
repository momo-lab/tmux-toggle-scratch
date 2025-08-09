#! /usr/bin/env bash

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$current_dir/helper.bash"

escape_tmux_formats() {
  local text=$(cat)
  text=$(echo "$text" | sed "s/#[^{]/.*/g")
  while echo "$text" | grep -q '#{[^#{}]*}'; do
    text=$(echo "$text" | sed "s/#{[^#{}]*}/.*/g")
  done
  echo $text
}

format=$(option_session_name_format)
pattern=$(echo "$format" | sed -e 's/[][)(\\.*^$+?|]/\\&/g' | escape_tmux_formats)
diff --old-line-format='' --unchanged-line-format='' --new-line-format='%L' \
  <(tmux list-panes -aF "$format" | uniq) \
  <(tmux list-sessions -F '#S' -f "#{m/r:${pattern},#S}") |
  xargs -I {} tmux kill-session -t {}
