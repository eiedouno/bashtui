declare -g _bashtui_draw_buffer
declare -g -A _bashtui_menu
declare -g -A _bashtui_menu_classes
declare -g _bashtui_menu_end

_bashtui_red+="\e[38;2;204;4;3m"
_bashtui_green+="\e[38;2;25;203;0m"
_bashtui_yellow+="\e[38;2;216;213;4m"
_bashtui_blue+="\e[38;2;13;115;204m"
_bashtui_purple+="\e[38;2;203;30;209m"

_bashtui_buffer_add() {
    if [[ -n "$_bashtui_draw_buffer" ]]; then
        _bashtui_draw_buffer+="\n$*"
    else
        _bashtui_draw_buffer+="$*"
    fi
}
