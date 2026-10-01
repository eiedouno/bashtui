tui_draw() {
    printf '%b' "$_bashtui_draw_buffer\n"

    if [[ -n "${!_bashtui_menu_classes[*]}" ]]; then
        local menuClass=${!_bashtui_menu_classes[*]}

        declare -n menuActor="${_bashtui_menu_classes[$menuClass]}"
        declare -n menuOptions=${menuActor[options]}
        local menuPrefix=${menuActor[prefix]}
        local menuSelectedPrefix=${menuActor[selectedPrefix]}

        local menuIndex=0
        local key rest buffer

        printf -v "${menuClass}_selected" ""
        _bashtui_menu_handler
    fi

    _bashtui_draw_buffer=""
    _bashtui_menu_classes=()
}

_bashtui_menu_handler() {
    trap ">&2 printf '%b' \"\e[?25h\e[0m\"; stty sane; exit" INT
    stty -echo
    printf '%b' "\e[?25l"
    printf '%b' "\x1b8"
    _bashtui_menu_end=

    while [[ "$_bashtui_menu_end" != "true" ]]; do

        IFS= read -rsn1 key
        if [[ $key == $'\e' ]]; then
            read -rsn2 -t 0.01 rest
            key+=$rest
        fi

        case $key in
        $'' | $'\e[C' | $'\eOC' | l)
            _bashtui_menu_end=true
            printf -v "${menuClass}_selected" "$menuIndex"
            ;;
        $' ') echo space ;;
        $'\e[A' | $'\eOA' | k) _bashtui_menu_event "up" ;;
        $'\e[B' | $'\eOB' | j) _bashtui_menu_event "down" ;;
        $'\e' | q | $'\e[D' | $'\eOD' | h) _bashtui_menu_end=true ;;
        esac
    done

    printf '%b' "\x1b8\e[J$\e[G\e[0m$menuPrefix${menuOptions[$menuIndex]}\e[?25h"
    stty sane
}

_bashtui_menu_event() {
    buffer="\e[49m\e[2K\e[G$menuPrefix${menuOptions[$menuIndex]}"

    if [[ "$1" == "up" ]]; then
        if [[ $menuIndex -ge 1 ]]; then
            buffer+="\e[0m\e[A\e[0m\e[2K\e[G\e[0m$menuSelectedPrefix\e[40m${menuOptions[$((menuIndex - 1))]}"
            ((menuIndex--))
        else
            return
        fi
    elif [[ "$1" == "down" ]]; then
        if [[ $menuIndex -lt $((${#menuOptions[@]} - 1)) ]]; then
            buffer+="\e[B\e[2K\e[G\e[0m$menuSelectedPrefix\e[40m${menuOptions[$((menuIndex + 1))]}"
            ((menuIndex++))
        else
            return
        fi
    else
        return
    fi

    printf '%b' "$buffer"
}

if [[ "$_bashtui_source" != "true" ]]; then
    tui_draw "$@"
    unset -f tui_draw
fi
