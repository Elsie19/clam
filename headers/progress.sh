#!/bin/bash
# @file progress.sh
# @brief A library for showing signs of progress.

# @section Functions
# @description Functions for outputting progress.

# Used from https://github.com/wick3dr0se/bashbar/blob/main/bashbar (GPLv3)

# @description Outputs a progress bar.
#
# @example
#   for _ in {1..100}; do progress.bar "${_}" 0.01; done
#
# @arg $1 optional `-c` to clear the progress bar after finishing.
# @arg $1 integer A position to set the progress bar.
# @arg $2 optional A delay time for the bar to continue.
#
# @exitcode 1 If position is less than 1 or greater than 100.
function progress.bar() {
    local width progress color clear
    if [[ ${1} =~ ^(-c|--clear) ]]; then
        readonly clear=1
        shift
    fi
    (($1 > 100 || $1 < 1)) && {
        echo "Enter an integer from 1-100 (percent)" >&2
        return 1
    }

    # shellcheck disable=SC2064
    trap "$(shopt -p checkwinsize)" RETURN
    shopt -s checkwinsize
    (:)

    exec {sleep_fd}<> <(:)
    read -r -t "${2:-0}" -u "${sleep_fd}"
    exec {sleep_fd}>&-
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

    (($1 == 100)) && {
        if ((clear == 1)); then
            echo -ne "\033[2K\r"
        else
            echo
        fi
    }
}

# @description Outputs a spinner.
#
# @example
#   sleep 6 &
#   le_pid="$!"
#   progress.spinner -d 0.1 -s '←  ↖↑↗→↘↓↙' "${le_pid}"
#
# @arg $1 optional `-d delay` to set a delay period for moving to next spinner.
# @arg $1 optional `-s spinners` A string of characters to use as a spinner.
# @arg $1 integer A PID to continue running until PID finishes.
function progress.spinner() {
    # shellcheck disable=SC1003
    local pid delay="0.1" temp spinner='|/-\' msg reset i OPTION
    while getopts ":d:m:s:" OPTION; do
        case "${OPTION}" in
            d) delay="${OPTARG}" ;;
            m) msg="${OPTARG}" ;;
            s) spinner="${OPTARG//[[:space:]]/}" ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-d delay] [-m msg] [-s spinners] pid" >&2 && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))
    readonly pid="${1:?No pid given to progress.spinner}"
    while [[ -L /proc/${pid}/exe ]]; do
        temp="${spinner#?}"
        echo -ne "[${spinner:0:1}] ${msg}"
        spinner="${temp}${spinner%"${temp}"}"
        exec {sleep_fd}<> <(:)
        read -r -t "${delay}" -u "${sleep_fd}"
        exec {sleep_fd}>&-
        reset="\b\b\b\b\b\b"
        for ((i = 1; i <= "${#msg}" + 1; i++)); do
            reset+="\b"
        done
        echo -ne "${reset}"
    done
    echo -ne "\033[2K\r"
}
