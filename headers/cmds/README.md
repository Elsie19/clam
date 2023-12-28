## Pure Bash coreutils

These headers correspond to their coreutils command. These really should not be used unless you don't have (for whatever reason) access to said commands. Most of these headers implement some flags/options, but not all.

| Command       | Missing features                             | Included features   |
|---------------|----------------------------------------------|---------------------|
| `cat.sh`      | `-A -b -e -s -t -T -v`                       | `-n -E`             |
| `sleep.sh`    | Decimal `s,m,h,d` due to Bash floating point | `s,m,h,d` suffix    |
| `tac.sh`      | Every flag                                   | All                 |
| `seq.sh`      | `-f -w`                                      | `-s`                |
| `ls.sh`       | Every flag                                   | `-b`                |
| `uname.sh`    | `-v -i -p`                                   | `-a -s -n -r -m -o` |
| `yes.sh`      | None                                         | All                 |
| `basename.sh` | `-s`                                         | `-z`                |
| `whoami.sh`   | None                                         | All                 |
| `fold.sh`     | `-b -s`                                      | `-w`                |
| `tee.sh`      | `-i -p`                                      | `-a`                |
| `cp.sh`       | `-r`                                         | Copies file         |
| `clear.sh`    | `-T -V`                                      | `-x`                |
| `uniq.sh`     | `-s -c -f -D --group -u -w -z`               | `-i`                |
