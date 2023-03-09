#!/bin/bash

function error.error() {
    local err_msg="${1:-"Unknown Error"}"
    local err="${2:-}"
    echo "${0}: line $(caller): ${err_msg}" 1>&2
    if [[ -n ${err} ]]; then
        exit "${err}"
    fi
}
