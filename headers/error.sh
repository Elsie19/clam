#!/bin/bash
# @file error.sh
# @brief A library for bash-like error messages.

# @section Functions
# @description Functions for bash-like error messages.

# @description Displays an error message
# @internal
#
# @example
#   error.error "'line' not defined"
#   error.error "'line' not defined" 1
#
# @arg $1 string Error message
# @arg $2 optional Exit code
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
