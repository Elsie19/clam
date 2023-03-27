#!/bin/bash

function cmds.tac() {
    local lines i
    # We are in a pipe
    if [[ -p /dev/stdin ]]; then
        mapfile -t lines <&0
    else
        mapfile -t lines < "${@}"
    fi

    for ((i = "${#lines[@]}" - 1; i >= 0; i--)); do
        echo "${lines[i]}"
    done
}
