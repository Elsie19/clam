#!/bin/bash

function assert.assert_eq() {
    local input1="${1:?}"
    local input2="${2:?}"

    if [[ ${input1} == "${input2}" ]]; then
        return 0
    else
        return 1
    fi
}

function assert.assert_not_eq() {
    ! assert.assert_eq "${1:?}" "${2:?}"
}

function assert.assert_contain() {
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

function assert.assert_not_contain() {
    local input1="${1:?}"
    shift
    local input2=("${@:?}")
    ! assert.assert_contain "${1}" "${input2[@]}"
}

function assert.is_root() {
    if (("${EUID}" != 0)); then
        return 0
    else
        return 1
    fi
}
