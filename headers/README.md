### Clam standard headers

These headers are included with every version of Clam. Most if not all of these headers are written in pure bash with no external dependencies, and exceptions will be listed below.

| Name 	       | Usage     |
|:------------:|-----------|
| `colors.sh`  | Implements a variety of colors + `$NO_COLOR` support |
| `msg.sh`     | Implements visually pleading output                  |
| `prompt.sh`  | Implements visually pleading prompts                 |
| `assert.sh`  | Implements assertion testing                         |
| `array.sh`   | Implements useful array tools                        |
| `tuple.sh`   | Implements tuples                                    |
| `error.sh`   | Implements standard error messages                   |
| `use.sh`     | Implements `using` from C++                          |
| `log.sh`     | Implements logging functionality                     |
| `types.sh`   | Implements stylized variable creations               |
| `ini.sh`     | Implements INI file support                          |
| `strings.sh` | Implements operations on strings                     |
| `debug.sh`   | Implements fancy debugging output                    |
| `sort.sh`    | Implements different sorting algorithms              |
| `progress.sh`| Implements progress bars                             |

### Headers with external dependencies
`log.sh` uses `mktemp` to create a temporary file, but will fallback to using a semi-random string generated for the file name by Bash if `mktemp` is not installed.

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

You now have access to `array.string_to_array`, `array.pop`, `array.remove`, `array.contain`, `array.join`, and `array.fill`.

> **Note**

> `array.pop` and `array.remove` are functional with associated arrays

`array.string_to_array` takes the form of `array.string_to_array "mystring" array_to_save_to`. Whitespace will be counted and added to the array as an empty element.

`array.pop` takes the form of `array.pop my_array index`.

`array.remove` takes the form of `array.pop my_array key`.

Both `pop` and `remove` will `return 1` if an array is `readonly`.

`array.contain` checks for the existence of a variable inside an array, and if not, return a value of `1`.

`array.join` takes the form of `array.join character_split ${array[@]}`

`array.fill` takes the form of `array.fill start_idx length char array`

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

array.join ',' ${haystack[@]}
# oats,grains,barley

boo=()
array.fill 0 10 b boo
# b b b b b b b b b b
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

#### `use.sh`

You now have access to `use`.

`use` accepts 1 input, that being the function you want to shorten.

Example:
```bash
use prompt.yes_no # Will be shortened to yes_no
use prompt.yes_no as yesno # Will be shortened to yesno
```

#### `log.sh`
`log.sh` is used for logging information to logfiles and for debugging purposes.

You now have access to `log.init`, `log.info`, `log.warn`, `log.error` and `log.cleanup`.

`log.init` accepts no arguments and will create a logfile using `mktemp` if available, and using a combination of `tr`, `/dev/urandom` and `head` to generate a file similar to the naming of `mktemp`. The variable `LOGFILE` is now globally available, but should not be used whenever possible.

`log.info`, `log.warn`, and `log.error` all accept 1 argument, and that is the text that you wish to log.

`log.cleanup` will simply delete `LOGFILE`

If the variable `DEBUG` is defined, `log.{info,warn,error}` will be outputed to the screen, with `colors.sh` support if included.

Example:
```bash
log.init

if ! prompt.yes_no "Do you like crayfish" like_crayfish; then
    error.error "Failed to get input!" 1
    exit 1
fi

log.info "The user responded ${like_crayfish:?}"
DEBUG=1
log.warn "Debugging mode was enabled!!"
# 2023-03-09_22:11:10 [warn]: Debugging mode was enabled!!
log.cleanup
```

#### `types.sh`

`types.sh` is used for stylized variable declarations. It's important to remember that an integer in Bash is just a string with numbers, and can easily be used like a string (such as `int foo=1 ; foo+="bar" # -> '1bar'`).

You now have access to `int` and `string`.

Example:
```bash
int foo=1
string foo="lestring"
```

#### `ini.sh`
`ini.sh` is used for turning INI files into native bash variables/arrays.

You now have access to `ini.parse`. It accepts two arguments, the first being the INI file to parse, and a second optional argument for the hashmap prefix. `ini.parse` will not execute any commands inside the INI file (such as `foo = $(rm -rf ~)`), and will be set as is.

If no section is provided, `Default` will be used.

Example:

```ini
# configuration.ini
# supports # and ; for comments
name = "Henry"
optional_whitespace="yup"
even_this    =          "quite so"

[settings]
wallpaper = /home/henry/wallpaper.png
malicious_maybe = "$(echo doing bad stuff)"
```

```bash
if ! ini.parse configuration.ini bla; then
    error.error "Could not parse properly!" 1
fi

echo "${bla_Default[name]}" # "Henry"
echo "${bla_Default[even_this]}" # "quite so"
echo "${bla_settings[wallpaper]}" # /home/henry/wallpaper.png
echo "${bla_settings[malicious_maybe]}" # "$(echo doing bad stuff)"
```

#### `strings.sh`
`strings.sh` is used for operating on strings.

You now have access to `strings.rev`, `strings.strip_leading`, `strings.string_trailing`, and `strings.strip`.

`strings.rev` accepts any number of arguments. If you are dealing with large amounts of text, consider using the command `rev` or if that is unavailable, run `LC_ALL=C LANG=C strings.rev your_string` to disable unicode support, which may speed up the reversal.

`strings.strip_leading`, `strings.strip_trailing`, and `strings.strip` accept 1 argument.

Example:
```bash
string="foo bar baz"
strings.rev "${string}" # zab rab oof
string="                 a"
strings.strip_leading "${string}" # a
string="a                 "
strings.strip_trailing "${string}" # a
string="        a                 "
strings.strip "${string}" # a
```

#### `debug.sh`
`debug.sh` is used to implement a fancier looking `set -x`.

You now have access to `debug.on` and `debug.off`.

Example:
```bash
debug.on
foo=1
echo "${foo}"
debug.off
```

Output:
```bash
foo=1
🔍 [debug:NOFUNC():14] - DEBUG: foo=1
echo "${foo}"
🔍 [debug:NOFUNC():15] - DEBUG: echo 1
1
debug.off
🔍 [debug:NOFUNC():16] - DEBUG: debug.off
🔍 [debug:debug.off():11] - DEBUG: set +vx
```

#### `sort.sh`
`sort.sh` is used for different array sorting algorithms.

You now have access to `sort.bubble`, `sort.gnome`, and `sort.insert`.

Example:
```bash
for i in {1..1000}; do
    arra+=("${RANDOM}")
done

sort.insert "arra"
echo "${arra[*]}"
```

#### `progress.sh`
`progress.sh` is used to implement stylish progress bars.

You now have access to `progress.bar` and `progress.spinner`.

`progress.bar` takes two arguments and one optional: a percent for the bar and an optional sleep time, and the optional argument being `-c` or `--clear` to clear the bar after finishing.

`progress.spinner` requires one argument: a pid number, however you can specify a delay and a message with the `-d` and `-m` flags, respectively.

Example:
```bash
# progress.bar
for i in {1..100}; do
    progress.bar "${i}" 0.1
done

for i in {1..100}; do
    progress.bar -c "${i}" 0.1
done
echo "Done..."

# progress.spinner
sleep 50
sleep_pid="${!}"
progress.spinner -d 0.2 -m "Waiting for command to finish..." "${sleep_pid}"
```
