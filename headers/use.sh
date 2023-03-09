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
    # shellcheck disable=SC2139
    alias "${to_be}"="${full_name}"
}
