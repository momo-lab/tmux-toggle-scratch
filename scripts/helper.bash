get_tmux_option() {
  local key="$1" default="$2"
  local value=$(tmux show-options -gqv "$key")
  echo "${value:-$default}"
}

option_keys() {
  get_tmux_option @toggle-scratch-keys "C-s"
}

option_root_keys() {
  get_tmux_option @toggle-scratch-root-keys ""
}

option_session_name_format() {
  get_tmux_option @toggle-scratch-session-name-format "#S-#I@scratch"
}

option_popup_options() {
  get_tmux_option @toggle-scratch-popup-options ""
}
