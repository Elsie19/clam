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
    local LC_COLLATE=C i j input part=0 special final_part counter pos=0 regex split_arr=()
    input="${1:?No input given to conversion.perm_to_octal}"
    # Check for size of string
    if ! [[ ${#input} =~ ^(9|10) ]]; then
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

    # Order checking
    for i in "${split_arr[@]}"; do
        # Special exception for the last set (Tt)
        if ((pos == 2)); then
            regex='^(r|-) (w|-) (x|T|t|-)'
            if ! [[ ${i} =~ ${regex} ]]; then
                return 1
            fi
        else
            regex='^(r|-) (w|-) (x|S|s|-)'
            if ! [[ ${i} =~ ${regex} ]]; then
                return 1
            fi
        fi
        ((pos++))
    done

    for i in "${split_arr[@]}"; do
        ((counter++))
        for j in ${i}; do
            case "${j}" in
                r) ((part += 4)) ;;
                w) ((part += 2)) ;;
                -) ;;
                T) ((special += 1)) ;;
                t) ((special += 1, part += 1)) ;;
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
    echo "${special:-0}${final_part}"
}

# @description Sets correct case for special bits on string.
# @internal
#
# @example
#   conversion._octal_to_perm_swap my_arr 9 T
#
# @arg $1 string An array.
# @arg $2 integer A position in the array.
# @arg $3 char A character to place in.
function conversion._octal_to_perm_swap() {
    case "${FUNCNAME[1]}" in
        conversion.octal_to_perm) ;;
        *) echo "Do not call 'conversion._octal_to_perm_swap' directly!" >&2 ;;
    esac
    local arr letter pos
    declare -n arr="${1:?No input given to conversion._octal_to_perm_swap}"
    pos="${2:?No position given to conversion._octal_to_perm_swap}"
    letter="${3:?No letter given to conversion._octal_to_perm_swap}"
    if [[ ${arr[pos]} == "-" ]]; then
        arr[pos]="${letter^^}"
    else
        arr[pos]="${letter,,}"
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
            3) perm_str+=(- w x) ;;
            2) perm_str+=(- w -) ;;
            1) perm_str+=(- - x) ;;
            0) perm_str+=(- - -) ;;
        esac
    done
    if ((special)); then
        case "${special}" in
            # Sticky bit
            1)
                conversion._octal_to_perm_swap perm_str 9 T ;;
            # GID
            2)
                conversion._octal_to_perm_swap perm_str 6 S ;;
            # UID
            4)
                conversion._octal_to_perm_swap perm_str 3 S ;;
            # Sticky+GID
            3)
                conversion._octal_to_perm_swap perm_str 9 T
                conversion._octal_to_perm_swap perm_str 2 S
                ;;
            # Sticky+UID
            5)
                conversion._octal_to_perm_swap perm_str 9 T
                conversion._octal_to_perm_swap perm_str 3 S
                ;;
            # GID+UID
            6)
                conversion._octal_to_perm_swap perm_str 6 S
                conversion._octal_to_perm_swap perm_str 3 S
                ;;
            # GID+UID+Sticky
            7)
                conversion._octal_to_perm_swap perm_str 9 T
                conversion._octal_to_perm_swap perm_str 6 S
                conversion._octal_to_perm_swap perm_str 3 S
                ;;
        esac
    fi
    local IFS=
    echo "${perm_str[*]}"
}
