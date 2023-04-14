#!/bin/bash
# @file file.sh
# @brief A library for abstracting away bash file conditionals.

# @section Functions
# @description Functions for abstracting conditionals.

# @description Checks if a file exists.
# @internal
#
# @example
#   file.file_exists /etc/os-release
#
# @arg $1 string A file.
function file.file_exists() {
    local file
    file="${1:?No file given to file.file_exists}"
    if [[ -f ${file} ]]; then
        return 0
    else
        return 1
    fi
}

# @description Checks if exists.
# @internal
#
# @example
#   file.exists /etc/os-release
#
# @arg $1 string A file.
function file.exists() {
    local file
    file="${1:?No file given to file.exists}"
    if [[ -e ${file} ]]; then
        return 0
    else
        return 1
    fi
}

# @description Checks if path is directory.
# @internal
#
# @example
#   file.is_directory /etc
#
# @arg $1 string A directory.
function file.is_directory() {
    local dir
    dir="${1:?No directory given to file.is_directory}"
    if [[ -d ${dir} ]]; then
        return 0
    else
        return 1
    fi
}

# @description Checks if file is readable.
# @internal
#
# @example
#   file.is_readable /etc/os-release
#
# @arg $1 string A file.
function file.is_readable() {
    local file
    file="${1:?No file given to file.is_readable}"
    if [[ -r ${file} ]]; then
        return 0
    else
        return 1
    fi
}

# @description Checks if file is symlink.
# @internal
#
# @example
#   file.is_symlink /bin/sh
#
# @arg $1 string A file.
function file.is_symlink() {
    local file
    file="${1:?No file given to file.is_symlink}"
    if [[ -L ${file} ]]; then
        return 0
    else
        return 1
    fi
}

# @description Checks if file is writable.
# @internal
#
# @example
#   file.is_writable /bin/sh
#
# @arg $1 string A file.
function file.is_writable() {
    local file
    file="${1:?No file given to file.is_writable}"
    if [[ -w ${file} ]]; then
        return 0
    else
        return 1
    fi
}

# @description Checks if file is executable.
# @internal
#
# @example
#   file.is_executable /bin/sh
#
# @arg $1 string A file.
function file.is_executable() {
    local file
    file="${1:?No file given to file.is_executable}"
    if [[ -x ${file} ]]; then
        return 0
    else
        return 1
    fi
}

# @description Checks if file has contents.
# @internal
#
# @example
#   touch foo
#   file.is_non_zero_size foo
#
# @arg $1 string A file.
function file.is_non_zero_size() {
    local file
    file="${1:?No file given to file.is_non_zero_size}"
    if [[ -s ${file} ]]; then
        return 0
    else
        return 1
    fi
}

# @description Checks if two files are the same.
# @internal
#
# @example
#   file.is_same /bin/sh /bin/dash
#
# @arg $1 string A file.
# @arg $2 string A file.
function file.is_same() {
    local file1 file2
    file1="${1:?No file given to file.is_non_zero_size}"
    file2="${2:?No file given to file.is_non_zero_size}"
    if [[ ${file1} -ef ${file2} ]]; then
        return 0
    else
        return 1
    fi
}

# @description Checks if file is special.
# @internal
#
# @example
#   file.is_special /dev/urandom
#
# @arg $1 string A file.
function file.is_special() {
    local file
    file="${1:?No file given to file.is_special}"
    if [[ -c ${file1} ]]; then
        return 0
    else
        return 1
    fi
}

# @description Checks if file is socket.
# @internal
#
# @example
#   file.is_socket /tmp/.X11-unix/X0
#
# @arg $1 string A file.
function file.is_socket() {
    local file
    file="${1:?No file given to file.is_socket}"
    if [[ -S ${file1} ]]; then
        return 0
    else
        return 1
    fi
}
