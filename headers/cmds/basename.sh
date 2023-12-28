#!/bin/bash

function cmds.basename() {
    local tmp ending replace string OPTION

    while getopts ':z:' OPTION; do
        case "${OPTION}" in
            z) ending=1 ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-z] NAME" >&2 && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    if ((${#@} > 2)); then
        echo "${FUNCNAME[0]}: extra operand '${3}'" >&2 && return 1
    fi

    replace="${2-}"
    string="${1}"

    tmp="${string%"${string##*[!/]}"}"
    tmp="${tmp##*/}"
    tmp="${tmp%"${replace/"${tmp}"/}"}"

    if [[ -n ${ending} ]]; then
        echo -n "${tmp:-/}"
    else
        echo "${tmp:-/}"
    fi
}
