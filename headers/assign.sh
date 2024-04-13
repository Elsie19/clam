#!/bin/bash
# @file assign.sh
# @brief A library for better looking variable assignment (without subshells)

# @section Functions
# @description Functions for setting variables

# @description Sets a variable
# @internal
#
# @example
#   assign.assign foo = ls
#   echo "${foo}"
#
# @arg $1 string Variable to assign
# @arg $2 string Equals sign
# @arg $3 string Command to run
# Thank you @vigress8
function assign.assign() {
    local var fd fifo text
    var="${1:?}"
    if [[ ${2} != "=" ]]; then
        echo "Invalid syntax: '${2}' should be '='" >&2
        return 1
    fi
    fifo="/tmp/assign_$var"
    shift 2
    mkfifo "$fifo"
    exec {fd}<> "$fifo"
    { "$@"; printf '\0'; } >&$fd &
    IFS= read -r -d '' text <&$fd
    printf -v "${var}" "%s" "${text%$'\n'}"
    exec {fd}>&-
    unlink "$fifo" 2>/dev/null
}
