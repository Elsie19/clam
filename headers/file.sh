#!/bin/bash

function is() {
    case "${1:?No argument passed to 'file'}" in
        dir) [[ -d ${2:?No dir passed to 'is dir'} ]] ;;
        fifo) [[ -p ${2:?No fifo passed to 'is fifo'} ]] ;;
        socket) [[ -S ${2:?No socket passed to 'is socket'} ]] ;;
        file) [[ -f ${2:?No file passed to 'is file'} ]] ;;
        symbolic) [[ -L ${2:?No file passed to 'is symbolic'} ]] ;;
        exists) [[ -e ${2:?No file passed to 'is exists'} ]] ;;
        readable) [[ -r ${2:?No file passed to 'is readable'} ]] ;;
        writable) [[ -w ${2:?No file passed to 'is writable'} ]] ;;
        executable) [[ -x ${2:?No file passed to 'is executable'} ]] ;;
        empty) [[ ! -s ${2:?No file passed to 'is empty'} ]] ;;
        newer)
            shift
            [[ ${1:?No left file passed to 'is newer'} -nt ${2:?No right file passed to 'is newer'} ]]
            ;;
        hardlink)
            shift
            [[ ${1:?No left file passed to 'is hardlink'} -ef ${2:?No right file passed to 'is hardlink'} ]]
            ;;
    esac
}
