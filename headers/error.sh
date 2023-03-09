#!/bin/bash

function error.error() {
    local err_msg="${1:-"Unknown Error"}"
    local err="${2-}"
    local lines
    mapfile -d " " lines < <(caller)
    if shopt -q gnu_errfmt; then
        echo "${0}:${lines[0]// /}: ${err_msg}" 1>&2
    else
        echo "${0}: line ${lines[0]// /}: ${err_msg}" 1>&2
    fi
    if [[ -n ${err} ]]; then
        exit "${err}"
    fi
}
