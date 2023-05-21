#!/bin/bash

function cmd.fold() {
    local file line OPTION size=80
    while getopts ':w:' OPTION; do
        case "${OPTION}" in
            w) size="${OPTARG}" ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-w width] files" >&2 && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))
    file="${1:?No file given to cmd.fold}"
    while IFS= read -r line; do
        if (("${#line}" > size)); then
            echo "${line:0:size}"
            echo "${line:size}"
        else
            echo "${line}"
        fi
    done < "${file}"
}
