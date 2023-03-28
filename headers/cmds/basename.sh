#!/bin/bash

function cmds.basename() {
    local OPTION MULTIPLE SUFFIX ZERO path name
    while getopts 's:z' OPTION ; do
        case "$OPTION" in
            s ) SUFFIX="$OPTARG" ;;
            z ) ZERO=true ;;
            ?) echo "Usage: ${FUNCNAME[0]} [-b] PATHS" && return 1 ;;
        esac
        shift $(( OPTIND - 1 ))
    done


    for path in "${@}" ; do
        name="${path##*/}"
        if [ -n "$SUFFIX" ]; then
            name="${name/\.${SUFFIX}}"
        fi

        echo -n "$name "

        if [ -z "$ZERO" ]; then
            echo ""
        fi
    done

}
