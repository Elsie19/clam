### Clam standard headers

These headers are included with every version of Clam.

Headers are generally grouped together into one meta-header, just like meta-packages. You should use those if said meta-header contains functionality you want instead of including it's headers by themselves. Generally, meta-headers have the prefix `std`.

| Name 	       | Usage     | Meta-header| Relations |
|--------------|-----------|:----------:|-----------|
| `stdout.sh`  | Used for all fancy output needs | ✔️ | None |
| `stdtest.sh` | Used for assertions    | ✔️ | None |
| `colors.sh`  | Implements a variety of colors + `$NO_COLOR` support | ❌ | Part of `stdout.sh` |
| `msg.sh`     | Implements visually pleading output | ❌ | Part of `stdout.sh` |
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

`assert_not_eq` flips the return value of `assert_eq`

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

`assert_not_contains` flips the return value of `assert_contains`
