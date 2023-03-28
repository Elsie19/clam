#!/bin/bash

function cmds.seq() {
    # shellcheck disable=SC2034
    local first increment last separator i OPTION
    while getopts ':s:' OPTION; do
        case "${OPTION}" in
            s) separator="${OPTARG}" ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-s separator] FIRST INCREMENT LAST" && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))
    case "${#@}" in
        0)
            echo "${FUNCNAME[0]}: missing operand" && return 1 ;;
        1)
            for ((i = 1; i <= ${1}; i++)); do
                # Print newline on last instance
                if ((i == "${1}")); then
                    printf "%s\n" "${i}"
                else
                    printf "%s${separator:-$'\n'}" "${i}"
                fi
            done
            ;;
        2)
            for ((i = "${1}"; i <= ${2}; i++)); do
                if ((i == "${2}")); then
                    printf "%s\n" "${i}"
                else
                    printf "%s${separator:-$'\n'}" "${i}"
                fi
            done
            ;;
        3)
            if ((${1} > ${3})); then
                # If we cannot reach from $1 to $3 using $2
                if [[ ${2:0:1} != "-" ]]; then
                    return 1
                fi
                for ((i = "${1}"; i >= ${3}; i += "${2}")); do
                    if ((i == "${3}")); then
                        printf "%s\n" "${i}"
                    else
                        printf "%s${separator:-$'\n'}" "${i}"
                    fi
                done
            else
                for ((i = "${1}"; i <= ${3}; i += "${2}")); do
                    if ((i == "${3}")); then
                        printf "%s\n" "${i}"
                    else
                        printf "%s${separator:-$'\n'}" "${i}"
                    fi
                done
            fi
            ;;
    esac
}
