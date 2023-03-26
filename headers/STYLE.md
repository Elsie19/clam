## Clam header styling

#### Best practices
When creating clam headers, remember that they should be entirely self-contained whenever possible. They should be designed to be as fault-tolerant as **possible**. Add error checking *everywhere*.

If you have to create another function outside your main one, prefix it with an underscore (`_`), like `lib._something`. Bonus points if you design the function to only run when called by the parent function ([Example](https://github.com/Henryws/clam/blob/2aa8e464315519f5d9d071fe09b70b873ec0dc17/headers/log.sh#L29))

Use as little external dependencies as possible (none is ideal). If there is a way to do something without a dependency, use it. The goal is that all of Clam could be run in an environment where no commands exist except for Bash. Since Clam is designed for Bash only, don't worry about portability. Use Bashisms where you must.

#### Style
All variables **must** be local to the function, however if you must export variables, make sure they are `readonly` if possible. Do **not** declare local variables as they are defined:
```bash
# GOOD
local i z b
i=1
z=2
b=3

# BAD
local i=1
local z=2
local b=3
```

If you must access an array outside of the function like you would with a pointer, use `declare -n`:
```bash
# Main script
foo=()
lib.convert foo

# Inside lib.convert
declare -n arr="${1:?Put an error message here}"
# arr is now a pointer to foo
```
