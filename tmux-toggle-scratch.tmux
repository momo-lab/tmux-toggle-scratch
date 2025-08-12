#! /usr/bin/env bash

# Check tmux version (3.2+ required for display-popup)
tmux -V | grep -q ' 3\.[2-9]\| [4-9]\.' || {
  tmux display-message "Error: tmux 3.2+ required for display-popup"
  exit 1
}

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$current_dir/scripts/helper.bash"

bind_command="if-shell -F '#{E:@__toggle-scratch-session-name}' \\
  'detach-client' \\
  'run-shell \"$current_dir/scripts/show-scratch-popup.bash\"'"

for key in $(option_keys); do
  tmux bind-key -N 'Toggle scratch popup' $key "$bind_command"
done

for key in $(option_root_keys); do
  tmux bind-key -T root -N 'Toggle scratch popup' $key "$bind_command"
done

if [[ "$(option_use_hooks)" == "on" ]]; then
  tmux set-hook -g 'pane-exited' "run-shell $current_dir/scripts/cleanup-session.bash"
  tmux set-hook -g 'after-kill-pane' "run-shell $current_dir/scripts/cleanup-session.bash"
  tmux set-hook -g 'window-unlinked' "run-shell $current_dir/scripts/cleanup-session.bash"
fi
