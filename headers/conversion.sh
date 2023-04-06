#!/bin/bash
# @file conversion.sh
# @brief A library for converting formats.

# @section Functions
# @description Functions for converting formats.

# @description Converts a hex code to RGB.
# @internal
#
# @example
#   conversion.hex_to_rgb "#FFFFFF"
#
# @arg $1 hex A hex to convert.
conversion.hex_to_rgb() {
    local r g b
    : "${1/\#/}"
    ((r = 16#${_:0:2}, g = 16#${_:2:2}, b = 16#${_:4:2}))
    printf '%s\n' "${r} ${g} ${b}"
}

# @description Converts RBG to a hex code.
# @internal
#
# @example
#   conversion.rgb_to_hex 255 255 255
#
# @arg $1 integer A red to convert.
# @arg $2 integer A green to convert.
# @arg $3 integer A blue to convert.
conversion.rgb_to_hex() {
    printf '%02x%02x%02x\n' "${1:?}" "${2:?}" "${3:?}"
}

conversion.perm_to_octal() {
    local LC_COLLATE=C ls_out extra=0 perms=0 i this_char
    while IFS= read -r ls_out; do
        extra=0
        perms=0
        for i in {1..9}; do
            # Shift $perms to the left one bit, so we can always just add the LSB.
            ((perms *= 2))
            this_char=${ls_out:i:1}
            # If it's different from its upper case equivalent,
            # it's a lower case letter, so the bit is set.
            # Unless it's "l" (lower case L), which is special.
            if [[ ${this_char} != "${this_char^}" && ${this_char} != "l" ]]; then
                ((perms++))
            fi
            # If it's not "r", "w", "x", or "-", it indicates that
            # one of the high-order (S/s=4000, S/s/L/l=2000, or T/t=1000) bits
            # is set.
            case "${this_char}" in
                [^rwx-])
                    ((extra += 2 ** (3 - i / 3)))
                    ;;
            esac
        done
        printf "%o%.3o\n" "${extra}" "${perms}"
    done <<< "${1:?No input given to conversion.perm_to_octal}"
}

conversion.octal_to_perm() {
    local input octal char perm_str="-"
    input="${1:?No input given to conversion.octal_to_perm}"
    [[ ${input} =~ ${input//?/(.)} ]]
    octal=("${BASH_REMATCH[@]:1}")
    for char in "${octal[@]}"; do
        case "${char}" in
            7) perm_str+="rwx" ;;
            6) perm_str+="rw-" ;;
            5) perm_str+="r-x" ;;
            4) perm_str+="r--" ;;
            2) perm_str+="-w-" ;;
            1) perm_str+="--x" ;;
            0) ;;
        esac
    done
    echo "${perm_str}"
}
