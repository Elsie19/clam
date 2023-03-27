#!/bin/bash

function cmds.cat() {
    local files i end number nonempty lineno
    while getopts 'Ebn' OPTION; do
        case "${OPTION}" in
            E) end='$' ;;
            n)
                # shellcheck disable=SC2034
                number=1 ;;
            b)
                # shellcheck disable=SC2034
                nonempty=1 ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-E] [-n] [-b] files" && return 1 ;;
        esac
        shift $((OPTIND - 1))
        readarray -t files < "${@}"
        lineno=1
        for i in "${files[@]}"; do
            if [[ -n "${number}" || -n "${nonempty}" ]]; then
                if [[ -n "${nonempty}" ]]; then
                    if [[ -z "${i}" ]]; then
                        echo
                    else
                        echo -e "     ${lineno}	 ${i}${end}"
                    fi
                else
                    echo -e "     ${lineno}	 ${i}${end}"
                fi
            else
                echo "${i}${end}"
            fi
            ((lineno++))
        done
    done
}
