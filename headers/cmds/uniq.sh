#!/bin/bash

function cmds.uniq() {
    local input=() output=() cased=() check_chars_tmp=() line prev_line ctr=1 ignore_case=1 check_chars=infinite OPTION OPTIND
    while getopts 'iw:' OPTION; do
        case "${OPTION}" in
            i) ignore_case=0 ;;
            w) check_chars="${OPTARG}" ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-i] [-w chars] [input [output]]" >&2 && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))
    if [[ -p /dev/stdin ]]; then
        mapfile -t input <&0
    else
        mapfile -t input < "${1:-/dev/stdin}"
    fi

    if ((ignore_case == 0)); then
        # We'll just lowercase everything so it's all the same.
        cased=("${input[@],,}")
    else
        cased=("${input[@]}")
    fi

    if [[ $check_chars != 'infinite' ]]; then
        for i in "${cased[@]}"; do
            check_chars_tmp+=("${i:0:check_chars}")
        done
        cased=("${check_chars_tmp[@]}")
    fi

    for line in "${cased[@]}"; do
        if [[ $line != "${prev_line}" ]]; then
            # Add from original list, with no case changes or shortening
            output+=("${input[ctr - 1]}")
            # Pull from the modified list
            prev_line="${cased[ctr - 1]}"
        fi
        if [[ -z ${prev_line} ]]; then
            prev_line="${cased[ctr - 1]}"
            ((ctr++))
            continue
        fi
        prev_line="${cased[ctr - 1]}"
        ((ctr++))
    done

    if [[ -n ${2} ]]; then
        printf '%s\n' "${output[@]}" > "${2}"
    else
        printf '%s\n' "${output[@]}"
    fi
}
