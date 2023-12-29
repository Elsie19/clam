#!/bin/bash

function cmds.ls() {
    local paths=() places=() tmp_places=() i z end_ctr=1 comma line_by_line=1 OPTION OPTIND
    while getopts 'm1' OPTION; do
        case "${OPTION}" in
            m) comma=, ;;
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
        # Current path
        paths=(".")
    fi
    for i in "${paths[@]}"; do
        places=("${i}"/*)
        if [[ ${paths[0]} == "." ]]; then
            for j in "${places[@]}"; do
                tmp_places+=("${j:2}")
            done
            places=("${tmp_places[@]}")
        fi
        for z in "${places[@]}"; do
            if ((line_by_line == 0)); then
                echo "${z##*/}"
            elif [[ -n ${comma} ]]; then
                if ((end_ctr == ${#places[@]})); then
                    echo "${z}"
                else
                    echo -n "${z}, "
                fi
                ((end_ctr++))
            else
                # Good luck 🫡
                max_idx=$((COLUMNS / 3 - 1))
                max_cols=$((max_idx < ${#places[@]} ? max_idx : ${#places[@]}))
            fi
        done
    done
}
