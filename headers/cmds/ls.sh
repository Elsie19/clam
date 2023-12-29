#!/bin/bash

function cmds.ls() {
    local paths=() places=() i z bash line_by_line=1 OPTION OPTIND
    while getopts 'b1' OPTION; do
        case "${OPTION}" in
            b) bash=1 ;;
            1) line_by_line=0 ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-b] PATHS" >&2 && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))
    if [[ -p /dev/stdin ]]; then
        line_by_line=0
    fi
    if ((${#@} > 0)); then
        paths=("$@")
    else
        paths=("${PWD}")
    fi
    for i in "${paths[@]}"; do
        places=("${i}"/*)
        for z in "${places[@]}"; do
            if ((line_by_line == 0)); then
                if [[ -n ${bash} ]]; then
                    echo "'${z##*/}'"
                else
                    echo "${z##*/}"
                fi
            fi
        done
    done
}
