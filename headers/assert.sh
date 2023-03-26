#!/bin/bash

function assert.assert_eq() {
    local input1="${1:?No \$1 input given to assert.assert_eq}"
    local input2="${2:?No \$2 input given to assert.assert_eq}"

    if [[ ${input1} == "${input2}" ]]; then
        return 0
    else
        return 1
    fi
}

function assert.assert_not_eq() {
    ! assert.assert_eq "${1:?}" "${2:?}"
}

function assert.is_root() {
    return $(("${EUID}" == 0 ? 0 : 1))
}
