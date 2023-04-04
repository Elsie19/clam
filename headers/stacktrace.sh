#!/bin/bash
# @file stacktrace.sh
# @brief A library for fancy stacktraces.

# @section Functions
# @description Functions for enabling stacktraces.

# @description Enable a stacktrace function.
# @internal
# @noargs
#
# @example
#   trap 'errexit' ERR
#   set -o errtrace -o nounset -o pipefail -o errexit
function errexit() {
    local i j stack_size func linen src tab_size="4"
    local stack_size=${#FUNCNAME[@]}
    echo -e "\nStacktrace [${0##*/}]:" >&2
    for ((i = stack_size - 1; i >= 1; i--)); do
        func="${FUNCNAME[i]}"
        [[ -z ${func} ]] && func='MAIN'
        linen="${BASH_LINENO[i - 1]}"
        src="${BASH_SOURCE[i]}"
        [[ -z ${src} ]] && src=non_file_source
        for ((j = 0; j <= tab_size; j++)); do echo -n " "; done
        if ((i == stack_size - 1)); then
            echo -e "${func}() ${src}:${linen}" >&2
        else
            echo -e "─→ ${func}() ${src}:${linen}" >&2
        fi
        ((tab_size += 4))
    done
}
