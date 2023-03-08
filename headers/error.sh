#!/bin/bash

function error.error() {
    local err="${1:-"Unknown Error"}"
    echo "${0}: line ${LINENO}: ${err}" 1>&2
}

function error.fail() {
    local err_msg="${1:-"Unknown Error"}" 
    local err="${2:-1}"
    error.error "${err_msg}"
    exit "${err}"
}
