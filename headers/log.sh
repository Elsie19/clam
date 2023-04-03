#!/bin/bash
# @file log.sh
# @brief A library for logging information.

# @section Functions
# @description Functions for logging.
#   If the DEBUG variable is enabled, logs will be printed on screen.

# @description Initializes a logfile.
# @noargs
# @set LOGFILE Readonly logfile location
#
# @example
#   log.init
#
# @exitcode 1 If LOGFILE var exists or file exists.
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

# @description Cleans the logfile.
# @noargs
#
# @example
#   log.cleanup
function log.cleanup() {
    rm "${LOGFILE:?LOGFILE not defined}" || return 1
}

# @description Base function for logging.
# @internal
#
# @arg $1 string Type of text to log.
# @arg $@ string Text to be logged.
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

# @description Logs standard debugging text.
#
# @example
#   log.info "Foobar"
#
# @arg $@ string Text to log
function log.info() {
    log._base "info" "${*:?No input given to log.info}"
}

# @description Logs warning text.
#
# @example
#   log.warn "Foobar"
#
# @arg $@ string Text to log
function log.warn() {
    log._base "warn" "${*:?No input given to log.warn}"
}

# @description Logs error messages.
#
# @example
#   log.error "Foobar"
#
# @arg $@ string Text to log
function log.error() {
    log._base "error" "${*:?No input given to log.error}"
}
