#!/bin/bash

function cmds.uniq() {
    local input=() output=() cased=() line prev_line ctr=1 ignore_case=1 OPTION
    while getopts 'i' OPTION; do
        case "${OPTION}" in
            i) ignore_case=0 ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-i] [input [output]]" >&2 && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))
    if [[ -p /dev/stdin ]]; then
        mapfile -t input <&0
    else
        mapfile -t input < "${1}"
    fi

    if ((ignore_case == 0)); then
        # We'll just lowercase everything so it's all the same.
        cased=("${input[@],,}")
    else
        cased=("${input[@]}")
    fi

    for line in "${cased[@]}"; do
        if [[ $line != "${prev_line}" ]]; then
            output+=("${line}")
            prev_line="${input[ctr - 1]}"
        fi
        if [[ -z ${prev_line} ]]; then
            prev_line="${input[ctr - 1]}"
            ((ctr++))
            continue
        fi
        prev_line="${input[ctr - 1]}"
        ((ctr++))
    done

    if ((${#@} <= 1)); then
        printf '%s\n' "${output[@]}"
    else
        printf '%s\n' "${output[@]}" > "${2}"
    fi
}
