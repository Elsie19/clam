## Pure Bash coreutils

These headers correspond to their coreutils command. These really should not be used unless you don't have (for whatever reason) access to said commands. Most of these headers implement some flags/options, but not all, and try to compatible with their GNU counterparts.

| Command       | Missing features                             | Included features   |
|---------------|----------------------------------------------|---------------------|
| `cat.sh`      | `-A -b -e -s -t -T -v`                       | `-n -E`             |
| `sleep.sh`    | Decimal `s,m,h,d` due to Bash floating point | `s,m,h,d` suffix    |
| `tac.sh`      | Every flag                                   | All                 |
| `seq.sh`      | `-f -w`                                      | `-s`                |
| `uname.sh`    | `-v -i -p`                                   | `-a -s -n -r -m -o` |
| `yes.sh`      | None                                         | All                 |
| `basename.sh` | `-s`                                         | `-z`                |
| `whoami.sh`   | None                                         | All                 |
| `tee.sh`      | `-i -p`                                      | `-a`                |
| `cp.sh`       | `-r`                                         | Copies file         |
| `clear.sh`    | `-T -V`                                      | `-x`                |
| `uniq.sh`     | `-s -c -f -D --group -u -z`                  | `-i -w`             |
| `wc.sh`       | `-c -L --total --files0-from` multiple files | `-m -w -l`          |

## Pure Bash builtins

Please don't use these they are only to see if I can.

| Builtin       | Missing features                             | Included features   |
|---------------|----------------------------------------------|---------------------|
| `cd.sh`       | `-L -P -e -@`                                | `cd` base           |
