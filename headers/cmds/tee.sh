#!/bin/bash

function cmds.tee() {
    local append=0 text input=() file OPTION
    while getopts 'a' OPTION; do
        case "${OPTION}" in
            a) append=1 ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-a] file" >&2 && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))
    file="${1}"
    if [[ -p /dev/stdin ]]; then
        mapfile -t -O"${#text[@]}" text <&0
    else
        while :; do
            read -r input
            echo "${input}"
        done
    fi
    echo "${text[@]}"
    if ((append == 0)) && [[ -n ${file} ]]; then
        echo "${text[@]}" > "${file}"
    else
        echo "${text[@]}" >> "${file}"
    fi
}
