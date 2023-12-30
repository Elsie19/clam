#!/bin/bash

function builtin.cd() {
    local SWAP constructed_path path pathy ctr=0 split_path=()
    # cd home
    if [[ -z ${1} ]]; then
        OLDPWD="${PWD}"
        PWD="${HOME}"
        return 0
    fi
    if [[ -f ${1} && ${1} != '-' ]]; then
        echo "${FUNCNAME[0]}: not a directory: ${1}" >&2 && return 1
    fi
    if [[ ! -d ${1} && ${1} != '-' ]]; then
        echo "${FUNCNAME[0]}: no such file or directory: ${1}" >&2 && return 1
    fi
    if [[ ${1} == '-' ]]; then
        SWAP="${PWD}"
        PWD="${OLDPWD}"
        echo "${PWD}"
        OLDPWD="${SWAP}"
    else
        OLDPWD="${PWD}"
        # Do we have something like `Projects/` where we can tack onto
        # the end of PWD
        if [[ ${1:0:1} != '/' ]]; then
            constructed_path="${PWD}/${1%/}"
        # Fancy stuff for '..'
        elif [[ ${1} == *'..'* || ${1} == '..' ]]; then
            if [[ ${1} == '..' ]]; then
                pathy="${PWD}/.."
            else
                pathy="${1}"
            fi
            IFS=/ read -ra split_path <<< "${pathy}"
            unset "split_path[0]"
            split_path=("${split_path[@]}")
            for path in "${split_path[@]}"; do
                if [[ ${path} == '..' ]]; then
                    unset "split_path[${ctr}]" "split_path[$((ctr - 1))]"
                fi
                ((ctr++))
            done
            split_path=("${split_path[@]}")
            printf -v constructed_path '/%s' "${split_path[@]}"
        else
            # If we do, we have a full path `/usr/share`, so overwrite
            constructed_path="${1%/}"
        fi
        PWD="${constructed_path}"
    fi
}
