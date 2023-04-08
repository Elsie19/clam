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
# @stdout RGB color code space delimited by R, G, and B.
conversion.hex_to_rgb() {
    local r g b
    : "${1/\#/}"
    ((r = 16#${_:0:2}, g = 16#${_:2:2}, b = 16#${_:4:2}))
    echo "${r} ${g} ${b}"
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
# @stdout Hex code.
conversion.rgb_to_hex() {
    printf '%02X%02X%02X\n' "${1:?}" "${2:?}" "${3:?}"
}

# @description Converts a permission string to an octal.
# @internal
#
# @example
#   conversion.perm_to_octal "-rwxr-xr-x"
#
# @arg $1 string A permission string.
# @stdout The octal.
conversion.perm_to_octal() {
    local LC_COLLATE=C i j input part=0 special final_part counter split_arr=()
    input="${1:?No input given to conversion.perm_to_octal}"
    # Check for size of string
    if ! [[ "${#input}" =~ ^(9|10) ]]; then
        return 1
    fi
    # Remove leading `-`
    if (("${#input}" == 10)); then
        input="${input:1}"
    fi
    for ((i = 1; i <= "${#input}" - 1; i++)); do
        if ! [[ ${input:i:1} =~ ^(-|r|w|x|d|S|s|L|l|T|t) ]]; then
            return 1
        fi
    done
    [[ ${input} =~ ${input//?/(.)} ]]
    input=("${BASH_REMATCH[@]:1}")
    split_arr=("${input[*]:0:3}")
    split_arr+=("${input[*]:3:3}")
    split_arr+=("${input[*]:6:3}")
    for i in "${split_arr[@]}"; do
        ((counter++))
        for j in ${i}; do
            case "${j}" in
                r) ((part += 4)) ;;
                w) ((part += 2)) ;;
                -) ;;
                t | T) ((special += 1, part += 1)) ;;
                S)
                    case "${counter}" in
                        # SID
                        1) ((special += 4)) ;;
                        # GID
                        2) ((special += 2)) ;;
                    esac
                    ;;
                s)
                    case "${counter}" in
                        # SID
                        1) ((special += 4)) ;;
                        # GID
                        2) ((special += 2)) ;;
                    esac
                    ;&
                x) ((part += 1)) ;;
            esac
        done
        final_part+="${part}"
        part=0
    done
    if [[ -n ${special} ]]; then
        echo "${special}${final_part}"
    else
        echo "${final_part}"
    fi
}

# @description Converts an octal to permission string.
# @internal
#
# @example
#   conversion.octal_to_perm 0755
#
# @arg $1 integer An octal.
# @stdout The permission string.
conversion.octal_to_perm() {
    local input octal char special perm_str=("-")
    input="${1:?No input given to conversion.octal_to_perm}"
    if (("${#input}" == 4)); then
        special="${input:0:1}"
        # Check for num
        if ! [[ ${special} =~ ^[0-9]+$ ]]; then
            return 1
        fi
        input="${input:1}"
    fi
    [[ ${input} =~ ${input//?/(.)} ]]
    octal=("${BASH_REMATCH[@]:1}")
    for char in "${octal[@]}"; do
        case "${char}" in
            7) perm_str+=(r w x) ;;
            6) perm_str+=(r w -) ;;
            5) perm_str+=(r - x) ;;
            4) perm_str+=(r - -) ;;
            2) perm_str+=(- w -) ;;
            1) perm_str+=(- - x) ;;
            0) perm_str+=(- - -) ;;
        esac
    done
    if ((special)); then
        case "${special}" in
            # Sticky bit
            1) perm_str[9]="T" ;;
            # GID
            2) perm_str[6]="s" ;;
            # UID
            4) perm_str[3]="s" ;;
            # Sticky+GID
            3)
                perm_str[9]="T"
                perm_str[2]="s"
                ;;
            # Sticky+UID
            5)
                perm_str[9]="T"
                perm_str[3]="s"
                ;;
            # GID+UID
            6)
                perm_str[6]="s"
                perm_str[3]="s"
                ;;
            # GID+UID+Sticky
            7)
                perm_str[9]="T"
                perm_str[6]="s"
                perm_str[3]="s"
                ;;
        esac
    fi
    local IFS=
    echo "${perm_str[*]}"
}
