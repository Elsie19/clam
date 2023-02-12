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
`colors.sh` implements a lot of colors and styles, and has builtin support for the `$NO_COLOR` variable (https://no-color.org/).

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
