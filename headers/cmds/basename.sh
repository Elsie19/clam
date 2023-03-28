#!/bin/bash

function cmds.basename() {
    # Usage: basename "path" ["suffix"]
    local tmp

    tmp="${1%"${1##*[!/]}"}"
    tmp="${tmp##*/}"
    tmp="${tmp%"${2/"$tmp"}"}"

    printf '%s\n' "${tmp:-/}"
}
