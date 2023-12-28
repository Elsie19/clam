#!/bin/bash

function cmds.wc() {
    local input=() byte_show=1 chars words_show=1 words lines_show=1 line lines tmp_line format_sp OPTION OPTIND
    while getopts 'cmwl' OPTION; do
        case "${OPTION}" in
            c | m) byte_show=0 ;;
            w) words_show=0 ;;
            l) lines_show=0 ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-c] [-m] [-w] [-l] [file]…" >&2 && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))
    if [[ -p /dev/stdin ]]; then
        mapfile input <&0
    else
        mapfile input < "${1}"
    fi

    for line in "${input[@]}"; do
        ((chars += "${#line}"))
    done
    for line in "${input[@]}"; do
        ((lines++))
    done
    for line in "${input[@]}"; do
        IFS=" " read -ra tmp_line <<< "${line}"
        ((words += "${#tmp_line[@]}"))
    done

    if ((byte_show == 1 && words_show == 1 && lines_show == 1)); then
        ((byte_show = 0, words_show = 0, lines_show = 0))
    fi

    # If one flag has been passed, because if all flags have been passed,
    # only 1 flag has been turned to 0, so 1 + 1 + 0 = 2
    if ((lines_show + words_show + byte_show == 2)); then
        format_sp="%s"
    else
        format_sp=" %s"
    fi

    if ((lines_show == 0)); then
        # shellcheck disable=SC2059
        printf "${format_sp}" "${lines}"
    fi
    if ((words_show == 0)); then
        # shellcheck disable=SC2059
        printf "${format_sp}" "${words}"
    fi
    if ((byte_show == 0)); then
        # shellcheck disable=SC2059
        printf "${format_sp}" "${chars}"
    fi
    if [[ -p /dev/stdin ]]; then
        echo
    else
        printf ' %s\n' "${1}"
    fi
}
