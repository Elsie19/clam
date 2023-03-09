### Clam standard headers

These headers are included with every version of Clam.

Headers are generally grouped together into one meta-header, just like meta-packages. You should use those if said meta-header contains functionality you want instead of including it's headers by themselves. Generally, meta-headers have the prefix `std`.

| Name 	       | Usage     | Meta-header| Relations |
|:------------:|-----------|:----------:|:---------:|
| `stdout.sh`  | Used for all fancy output needs | ✔️ | None |
| `stdtest.sh` | Used for assertions    | ✔️ | None |
| `colors.sh`  | Implements a variety of colors + `$NO_COLOR` support | ❌ | Part of `stdout.sh` |
| `msg.sh`     | Implements visually pleading output | ❌ | Part of `stdout.sh` |
| `prompt.sh`  | Implements visually pleading prompts | ❌ | Part of `stdout.sh` |
| `assert.sh`  | Implements assertion testing | ❌ | Part of `stdtest.sh` |
| `array.sh`   | Implements useful array tools| ❌ | None |
| `tuple.sh`   | Implements tuples | ❌ | None |
| `error.sh`   | Implements standard error messages | ❌ | None |

### Header docs

#### `colors.sh`
`colors.sh` implements a lot of colors and styles, and has builtin support for the `$NO_COLOR` variable (https://no-color.org/), which will set every color variable to empty.

First off, you now have access to the `$BOLD`, `$NORMAL`, `$NC`, `$BLINK`, `$ITALIC`, and `$CROSS_OUT` variables. `$BOLD` will set the current color to be bolded. `$NC` will clear the formatting of any string. `$NORMAL` is functionally the same as `$NC`, but uses `tput` as the backend instead of raw ascii codes. It is recommended to use `$NC` unless you for some reason **must** use a `tput` backend to clear color codes. `$BLINK` will blink text (on supported terminals), `$ITALIC` is used to produce italic text (on supported terminals), and the same is for `$CROSS_OUT`.

```bash
# The `-e` must be included, *or* use `msg.sh`
echo -e "${BOLD}I am bolded!${NC} And I am not!"
```

The base color pallete is as follows:

`$BLACK`, `$RED`, `$GREEN`, `$YELLOW`, `$BLUE`, `$PURPLE`, `$CYAN`, `$WHITE`.

Every format after the base colors will use the base color names.

* Bold: Prepend the letter `B` to your sentence case base color variable (`$BRed`, `$BBlue`, etc)
* Underline: Prepend the letter `U` to your sentence case base color variable (`$URed`, `$UBlue`, etc)
* Background: Prepend the text `On_` to your sentence case base color variable (`$On_Red`, `$On_Blue`, etc)
* High intensity: Prepend the letter `I` to your sentence case base color variable (`$IRed`, `$IBlue`, etc)
* High intensity background: Prepend the text `On_I` to your sentence case base color variable (`$On_IRed`, `$On_IBlue`, etc)

#### `msg.sh`
`msg.sh` implements visually pleasing, and correctly redirected output.

You have access to the `msg` now. `msg` will print out text with the `>` being bolded green.
```bash
msg 'hello'

# > hello
```

`msg` can take the `-n` argument for printing without a newline.

#### `assert.sh`
`assert.sh` is used for testing and comparing output.

You now have access to the following functions:

`assert.assert_eq`, `assert.assert_not_eq`, and `assert.is_root`.

`assert.assert_eq` will test if two outputs are identical, and if not, return a value of `1`.

Example:
```bash
var1="$(( 10 / 2 ))"
var2="$(bc <<< '10 / 2')"
assert.assert_eq "${var1}" "${var2}"

# Returns 0

var1="$(( 10 / 2 ))"
var2="$(( 10 / 3 ))"
assert.assert_eq "${var1}" "${var2}"

# Returns 1
```

`assert.assert_not_eq` flips the return value of `assert.assert_eq`.

`assert.is_root` checks if the current user has an `$EUID` of `0`, and if so, will return `1`, and if not, will return `0`.

Example:
```bash
if assert.is_root; then
    error.error "You are not root" 1
fi
```

#### `prompt.sh`
`prompt.sh` is used for creating pleasing and correct prompts.

You now have access to `prompt.input` and `prompt.yes_no`. `prompt.input` is used for general prompts, whereas `prompt.yes_no` is used for creating yes/no prompts.

`prompt.yes_no` takes the form of `prompt.yes_no "My prompt" variable_to_save_to`. If it recieves input that is not a form of the letters `Y` or `N`, it will return with a value of `1`, which is why that possible exception *must* be handled in your code. If a `Y` is given, `variable_to_save_to` will be set to `Y`, and vice versa for `N`.

Example:
```bash
if ! prompt.yes_no "Do you like crayfish" like_crayfish; then
    error.error "Failed to get input!" 1
    exit 1
fi

# Note the `:?` in case any bugs slip through that leave the variable empty
case "${like_crayfish:?}" in
    "Y") msg "You do like crayfish" ;;
    "N") msg "You don't like crayfish" ;;
esac
```

`prompt.input` is simpler. It takes the form of `prompt.input "My prompt" variable_to_save_to`. It has no guarantees about what the input may be (including the absence of input).

Example:
```bash
prompt.input "What is the meaning of life" fourty_two

# shellcheck disable=SC2154
msg "According to you, the meaning of life is ${fourty_two}"
# Or if you want to fail if the input is empty:
msg "According to you, the meaning of life is ${fourty_two:?Error explanation}"
```

#### `array.sh`
`array.sh` is used for converting strings to arrays.

You now have access to `array.string_to_array`, `array.pop`, `array.remove`, and `array.contain`.

> **Note**

> `array.pop` and `array.remove` are functional with associated arrays

`array.string_to_array` takes the form of `array.string_to_array "mystring" array_to_save_to`. Whitespace will be counted and added to the array as an empty element.

`array.pop` takes the form of `array.pop my_array index`.

`array.remove` takes the form of `array.pop my_array key`.

Both `pop` and `remove` will `return 1` if an array is `readonly`.

`array.contain` checks for the existence of a variable inside an array, and if not, return a value of `1`.

Example:
```bash
mystring="foo baz"
array.string_to_array "${mystring}" foobarray

for char in "${foobarray}"; do
    echo "${char}"
done

# Output
# f
# o
# o
# 
# b
# a
# z

foo=(1 2 3)
array.pop foo 0
declare -p foo
# declare -a foo=([0]="2" [1]="3")

declare -A colors=([red]="#ff0000" [green]="#00ff00" [blue]="#0000ff")
array.remove colors "#00ff00"
# declare -A colors=([red]="#ff0000" [blue]="#0000ff")

needle="barley"
haystack=("oats" "grains" "barley")

array.contain "${needle}" "${haystack[@]}"

# Returns 0

needle="cat"
array.contain "${needle}" "${haystack[@]}"

# Returns 1
```

#### `tuple.sh`
`tuple.sh` is used for creating [tuples](https://en.wikipedia.org/wiki/Tuple).

You now have access to `tuple`.

`tuple` accepts at mininum, 2 inputs: the tuple variable name (`$1`), and it's input (`$@`).

Example:
```bash
tuple my_tuple 1 "String" "${another_array[@]}"

my_tuple+=("FAILS!")
```

#### `error.sh`
`error.sh` is used for raising errors with standard bash-like error messages with `shopt -s gnu_errfmt` support.

You now have access to `error.error`.

`error.error` accepts 2, an error message and an *optional* exit code.

Example:
```bash
possible_missing_cmd || error.error "Could not find $cmd. Cleaning up" && {
    cleanup_function
    error.error "Could not sucessfully run $cmd" 1
}
```
