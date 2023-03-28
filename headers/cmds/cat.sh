#!/bin/bash

function cmds.cat() {
    local files=() i z end number lineno=1 tabbing OPTION
    while getopts 'En' OPTION; do
        case "${OPTION}" in
            E) end='$' ;;
            n) number=1 ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-E] [-n] files" && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))
    for i in "${@}"; do
        if [[ ${i} != "-" ]]; then
            mapfile -t -O"${#files[@]}" files < "${i}"
        else
            mapfile -t -O"${#files[@]}" files <&0
        fi
    done
    for i in "${files[@]}"; do
        # 10 would be 2 chars, 500 would be 3
        tabbing="$((5 - "${#lineno}"))"
        if [[ -n ${number} ]]; then
            for ((z = 0; z <= tabbing; z++)); do
                echo -n ' '
            done
            if [[ -z ${i} ]]; then
                echo "${lineno}  ${end-}" && ((lineno++)) && continue
            fi
            echo "${lineno}  ${i}${end-}"
        else
            echo "${i}${end-}"
        fi
        ((lineno++))
    done
}
