#!/bin/bash

function log.init() {
    if [[ -n ${LOGFILE} && -f ${LOGFILE} ]]; then
        return 1
    fi
    if ! command -v mktemp &> /dev/null; then
        local chars=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
        local random_string
        for _ in {1..10}; do
            random_string+="${chars:RANDOM%${#chars}:1}"
        done
        : > "/tmp/tmp.${random_string}"
        declare -r LOGFILE="/tmp/tmp.${random_string}"
        export LOGFILE
    else
        # shellcheck disable=SC2155
        declare -gr LOGFILE="$(mktemp)"
    fi
}

function log.cleanup() {
    rm "${LOGFILE:?LOGFILE not defined}" || return 1
}

function log._base() {
    case "${FUNCNAME[1]}" in
        log.info | log.warn | log.error) ;;
        *) echo "Do not call 'log._base' directly!" >&2 ;;
    esac
    local type="${1:?No type given to log._base}"
    shift
    local rest="${*}"
    case "${type}" in
        info) local colortype='BGreen' && local color="${!colortype}" ;;
        warn) local colortype='BYellow' && local color="${!colortype}" ;;
        error) local colortype='BRed' && local color="${!colortype}" ;;
        *) ;;
    esac
    # shellcheck disable=SC2155
    local datetime="$(printf '%(%F_%T)T')"
    if [[ -n ${DEBUG} ]]; then
        echo -e "${datetime} [${color-}${type}${NC-}]: ${color-}${rest}${NC-}" | tee -a "${LOGFILE:?LOGFILE not defined}"
    else
        echo -e "${datetime} [${type}]: ${rest:?No input given to log.${FUNCNAME[0]}}" >> "${LOGFILE:?LOGFILE not defined}"
    fi
}

function log.info() {
    log._base "info" "${*:?No input given to log.info}"
}

function log.warn() {
    log._base "warn" "${*:?No input given to log.warn}"
}

function log.error() {
    log._base "error" "${*:?No input given to log.error}"
}
