tui_createMenu() {
    declare -n ACTOR=$1
    declare -n options=${ACTOR[options]}
    local class=${ACTOR[class]}
    local prefix=${ACTOR[prefix]}
    local selectedPrefix=${ACTOR[selectedPrefix]}
    local option _nl prev

    if [[ -n "${ACTOR[class]}" ]]; then
        _bashtui_menu[$class]+=${ACTOR[options]}
    else
        >&2 printf '%b' "\e[31m[bashtui]: you must specify a class for a menu\n"
        exit 1
    fi

    if [[ -z "${_bashtui_menu[$class]}" ]]; then
        >&2 printf '%b' "\e[31m[bashtui]: you cannot specify two menus in one draw call. Wait until after the exising draw to initialize it.\n"
        exit 1
    fi
    _bashtui_menu_classes[$class]="$1"

    if [[ -z "$options" ]]; then
        >&2 printf '%b' "\e[31m[bashtui]: no options were specified. Please double-check variable name\n"
        exit 1
    fi

    printf -v _nl '%*s' "$((${#options[@]} + 3))" ''
    _bashtui_draw_buffer+=${_nl// /$'\n'}
    _bashtui_draw_buffer+="\e[$((${#options[@]} + 3))A"

    for option in "${options[@]}"; do

        # this isn't _bashtui_buffer_add because it's unreliable for proper cursor placement
        if [[ -z "$prev" ]]; then
            _bashtui_draw_buffer+="\n\e[J\x1b7$selectedPrefix\e[40m$option\e[49m"
            prev=1
        else
            _bashtui_draw_buffer+="\n$prefix$option"
        fi

    done

    if [[ "${ACTOR[disableHints]}" != 1 ]]; then
        _bashtui_buffer_add "\e[0m\n\e[40m ↑/↓ ㆍmove | → ㆍselect | ESC/q ㆍexit"
    fi
}

if [[ "$_bashtui_source" != "true" ]]; then
    tui_createMenu "$@"
    unset -f tui_createMenu
fi
