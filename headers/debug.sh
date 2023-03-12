#!/bin/bash

function debug.on() {
    # Thanks to @sirhalos (https://github.com/sirhalos/bash-standard-library/blob/master/__init__.sh#L41)
    declare -gx PS4=$'\U1F50D $(tput sgr0)$(tput bold)$(tput setaf 1)$(tput setaf 7)[$(tput setaf 5)$(basename ${BASH_SOURCE[0]}):$(tput setaf 4)${FUNCNAME[0]:-NOFUNC}():$(tput setaf 3)${LINENO}$(tput setaf 7)] - $(tput setaf 3)DEBUG: $(tput sgr0)'
    set -vx
}

function debug.off() {
    set +vx
}
