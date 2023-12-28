#!/bin/bash

function cmds.clear() {
    if [[ $1 == "-x" ]]; then
        # Clear screen but keep scrollbuffer
        printf '\33[H\33[2J'
    else
        # Clear screen and scrollbuffer
        printf "\033c"
    fi
}
