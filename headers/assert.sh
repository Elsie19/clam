#!/bin/bash

function assert_eq() {
    local input1="${1:?}"
    local input2="${2:?}"

    if [[ ${input1} == "${input2}" ]]; then
        return 0
    else
        return 1
    fi
}

function assert_not_eq() {
    ! assert_eq "${1:?}" "${2:?}"
}

function assert_contain() {
    local item="${1:?}"
    shift
    local to_search=("${@:?}")
    for i in "${to_search[@]}"; do
        if [[ ${item} == "${i}" ]]; then
            return 0
        fi
    done
    return 1
}

function assert_not_contain() {
    local input1="${1:?}"
    shift
    local input2=("${@:?}")
    ! assert_contain "${1}" "${input2[@]}"
}
