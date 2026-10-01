create_tui_textinput() {

}

if [[ "$_bashtui_source" != "true" ]]; then
    create_tui_textinput "$@"
    unset -f create_tui_textinput
fi
