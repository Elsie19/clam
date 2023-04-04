#!/bin/bash
# @file use.sh
# @brief A library for namespacing imports.

# @section Functions
# @description Functions for namespacing imports.

# @description Namespaces imports.
# Uses `alias` to circuit function to alias name
#
# @example
#   use strings.rev
#   use prompt.yes_no as yesno
#
# @arg $1 string A function to shorten.
function use() {
    shopt -s expand_aliases
    local full_name="${1:?No input given for use}"
    if [[ ${2} == "as" && -n ${3} ]]; then
        local to_be="${3}"
    else
        local to_be="${full_name##*.}"
    fi
    if [[ ${full_name} == "${to_be}" ]]; then
        return 0
    fi
    if [[ "$(type -t "${to_be}")" == "alias" ]]; then
        echo "'${to_be}' is already a defined alias" >&2
        exit 1
    elif [[ "$(type -t "${to_be}")" == "function" ]]; then
        shopt -s extdebug
        mapfile -d " " whereis < <(declare -Ff "${to_be}")
        echo "'${to_be}' is already a defined function on line ${whereis[1]}" >&2
        shopt -u extdebug
        exit 1
    fi
    # We do **not** want the alias to be expanded at when it runs.
    # What we want is for it to be expanded right now,
    # So that it won't be checked for `full_name` at run.
    # shellcheck disable=SC2139
    alias "${to_be}"="${full_name}"
}
