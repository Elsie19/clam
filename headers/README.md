### Clam standard headers

These headers are included with every version of Clam.

Headers are generally grouped together into one meta-header, just like meta-packages. You should use those if said meta-header contains functionality you want instead of including it's headers by themselves. Generally, meta-headers have the prefix `std`.

| Name 	       | Usage     | Meta-header| Relations |
|--------------|-----------|:----------:|-----------|
| `stdout.sh`  | Used for all fancy output needs | ✔️ | None |
| `stdtest.sh` | Used for assertions    | ✔️ | None |
| `colors.sh`  | Implements a variety of colors + `$NO_COLOR` support | ❌ | Part of `stdout.sh` |
| `msg.sh`     | Implements visually pleading output | ❌ | Part of `stdout.sh` |
| `prompt.sh`  | Implements visually pleading prompts | ❌ | Part of `stdout.sh` |
| `assert.sh`  | Implements assertion testing | ❌ | Part of `stdtest.sh` |

### Header docs

#### `colors.sh`
`colors.sh` implements a lot of colors and styles, and has builtin support for the `$NO_COLOR` variable (https://no-color.org/), which will set every color variable to empty.

First off, you now have access to the `$BOLD`, `$NORMAL` and `$NC` variables. `$BOLD` will set the current color to be bolded. `$NC` will clear the formatting of any string. `$NORMAL` is functionally the same as `$NC`, but uses `tput` as the backend instead of raw ascii codes. It is recommended to use `$NC` unless you for some reason **must** use a `tput` backend to clear color codes.

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

You have access to `msg` and `err` functions now. `msg` will print out text with the `>` being bolded green, and `err` will print out text with the `>` being bolded red:
```bash
msg 'hello'

# > hello
```

`err` will also redirect to `stderr`, which will allow programs to filter through information without seeing any extra messages.

#### `assert.sh`
`assert.sh` is used for testing and comparing output.

You now have access to the following functions:

`assert_eq`, `assert_not_eq`, `assert_contains`, `assert_not_contains`.

`assert_eq` will test if two outputs are identical, and if not, return a value of `1`.

Example:
```bash
var1="$(( 10 / 2 ))"
var2="$(bc <<< '10 / 2')"
assert_eq "${var1}" "${var2}"

# Returns 0

var1="$(( 10 / 2 ))"
var2="$(( 10 / 3 ))"
assert_eq "${var1}" "${var2}"

# Returns 1
```

`assert_not_eq` flips the return value of `assert_eq`.

`assert_contains` checks for the existence of a variable inside an array, and if not, return a value of `1`.

Example:
```bash
needle="barley"
haystack=("oats" "grains" "barley")

assert_contains "${needle}" "${haystack[@]}"

# Returns 0

needle="cat"
assert_contains "${needle}" "${haystack[@]}"

# Returns 1
```

`assert_not_contains` flips the return value of `assert_contains`.

#### `prompt.sh`
`prompt.sh` is used for creating pleasing and correct prompts.

You now have access to `prompt_input` and `prompt_yes_no`. `prompt_input` is used for general prompts, whereas `prompt_yes_no` is used for creating yes/no prompts.

`prompt_yes_no` takes the form of `prompt_yes_no "My prompt" variable_to_save_to`. If it recieves input that is not a form of the letters `Y` or `N`, it will return with a value of `1`, which is why that possible exception *must* be handled in your code. If a `Y` is given, `variable_to_save_to` will be set to `Y`, and vice versa for `N`.

Example:
```bash
if ! prompt_yes_no "Do you like crayfish" like_crayfish; then
    err "Failed to get input!"
    exit 1
fi

# Note the `:?` in case any bugs slip through that leave the variable empty
case "${like_crayfish:?}" in
    "Y") msg "You do like crayfish" ;;
    "N") msg "You don't like crayfish" ;;
esac
```

`prompt_input` is simpler. It takes the form of `prompt_input "My prompt" variable_to_save_to`. It has no guarantees about what the input may be (including the absence of input).

Example:
```bash
prompt_input "What is the meaning of life" fourty_two

# shellcheck disable=SC2154
msg "According to you, the meaning of life is ${fourty_two}"
```
