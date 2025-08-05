get_session_name_format() {
  local default="#S-#I@scratch"
  tmux display-message -pF \
    "#{?@toggle-scratch-session-name-format,#{@toggle-scratch-session-name-format},#{l:${default}}}"
}
