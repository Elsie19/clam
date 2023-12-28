#!/bin/bash

function cmds.uname() {
    local OPTION OPTIND i proc_version=() output=() out_arr=()
    while getopts 'asnrmo' OPTION; do
        case "${OPTION}" in
            a)
                output=('kernel_name' 'nodename' 'kernel_release' 'machine')
                ;;
            s)
                output+=('kernel_name')
                ;;
            n)
                output+=('nodename')
                ;;
            r)
                output+=('kernel_release')
                ;;
            m)
                output+=('machine')
                ;;
            o)
                output+=('operating_system')
                ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-a] [-s] [-n] [-r] [-m] [-o]" >&2 && return 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    mapfile -t -d " " proc_version < /proc/version

    if (("${#output[@]}" == 0)); then
        echo "Usage: ${FUNCNAME[0]} [-a] [-s] [-n] [-r] [-m] [-o]" >&2 && return 1
    fi
    for i in "${output[@]}"; do
        case "${i}" in
            kernel_name)
                if [[ ${OSTYPE} == "linux-gnu" ]]; then
                    out_arr+=("Linux")
                else
                    out_arr+=("${i}")
                fi
                ;;
            nodename)
                out_arr+=("${HOSTNAME}")
                ;;
            kernel_release)
                out_arr+=("${proc_version[2]}")
                ;;
            machine)
                out_arr+=("${HOSTTYPE}")
                ;;
            operating_system)
                if [[ $OSTYPE == "linux-gnu" ]]; then
                    out_arr+=("GNU/Linux")
                fi
                ;;
            *) ;;
        esac
    done
    echo "${out_arr[*]}"
}
