#!/bin/bash

function cmds.cp() {
    local file target
    # echo **/* to get all recursive files but we can't because bash can't
    # do mkdir, oh well
    # shopt -s globstar nullglob dotglob
    shift $((OPTIND - 1))
    file="${1:?cmds.cp: missing file name}"
    target="${2:?cmds.cp: missing target file name}"
    if ! [[ -f "${file}" ]]; then
        echo "${FUNCNAME[0]}: file not found" >&2 && return 1
    fi
    printf '%s\n' "$(<"${file}")" > "${target}"
}
