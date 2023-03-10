#!/bin/bash

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
    # shellcheck disable=SC2139
    alias "${to_be}"="${full_name}"
}
