#!/bin/bash

function cmds.ls() {
    local paths=() places=() i z bash OPTION OPTIND
    while getopts 'b' OPTION; do
        case "${OPTION}" in
            b) bash=1 ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-b] PATHS" >&2 && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))
    paths=("$@")
    for i in "${paths[@]}"; do
        places=("${i}"/*)
        for z in "${places[@]}"; do
            if [[ -n ${bash} ]]; then
                echo "'${z##*/}'"
            else
                echo "${z##*/}"
            fi
        done
    done
}
