#!/bin/bash

# Used from https://github.com/wick3dr0se/bashbar/blob/main/bashbar (GPLv3)
function progress.bar() {
    local width progress color
    (($1 > 100 || $1 < 1)) && {
        echo "Enter an integer from 1-100 (percent)" >&2
        return 1
    }

    shopt -s checkwinsize
    (
        :
        :
    )

    sleep "${2:-0}"
    width="$((COLUMNS - 4))"
    progress="$(($1 * width / 100))"

    if [[ -z ${NO_COLOR} ]]; then
        if (($1 > 68)); then
            color=2
        elif (($1 > 34)); then
            color=3
        fi
    else
        color=0
    fi

    # shellcheck disable=SC2183
    printf '\r|\e[4%dm%*s\e[m' "${color:-1}" "${progress}"
    printf '\e[%dG|%d%%' "${width}" "${1}"

    (($1 == 100)) && echo
}
