tui_createText() {
    declare -n ACTOR=$1
    local bold
    local color
    local colorid
    local buffer

    if [[ "${ACTOR[bold]}" == "true" ]]; then
        buffer+="\e[1m"
    else
        buffer+="\e[0m"
    fi

    if [[ -n "${ACTOR[color]}" ]]; then
        if [[ "${ACTOR[color]}" == "red" ]]; then
            buffer+="$_bashtui_red"
        elif [[ "${ACTOR[color]}" == "green" ]]; then
            buffer+="$_bashtui_green"
        elif [[ "${ACTOR[color]}" == "yellow" ]]; then
            buffer+="$_bashtui_yellow"
        elif [[ "${ACTOR[color]}" == "blue" ]]; then
            buffer+="$_bashtui_blue"
        elif [[ "${ACTOR[color]}" == "purple" ]]; then
            buffer+="$_bashtui_purple"
        else
            >&2 printf '%b' "\e[31m[bashtui]: color doesn't exist, $1\n"
            exit 1
        fi
    fi

    if [[ -n "${ACTOR[colorid]}" ]]; then
        buffer+="\e[${ACTOR[colorid]}m"
    fi

    buffer+="${ACTOR[text]}"
    _bashtui_buffer_add "$buffer"
}

if [[ "$_bashtui_source" != "true" ]]; then
    tui_createText "$@"
    unset -f tui_createText
fi
