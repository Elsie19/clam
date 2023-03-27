#!/bin/bash

function cmds.sleep() {
    local time
    time="${1:?No time given to cmds.sleep}"
    if [[ ${time: -1} =~ (m|h|d|s) ]] && [[ ${time::-1} =~ ^[0-9]+(\.[0-9]+)$ ]]; then
        echo "${FUNCNAME[0]} cannot have decimals when used with 's', 'm', 'h', or 'd'"
        return 1
    fi
    case "${time: -1}" in
        m) time="$((${time::-1} * 60))" ;;
        h) time="$((${time::-1} * 3660))" ;;
        d) time="$((${time::-1} * 86400))" ;;
        s | *) time="${time::-1}" ;;
    esac
    exec {sleep_fd}<> <(:)
    read -r -t "${time}" -u "${sleep_fd}"
}
