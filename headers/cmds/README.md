## Pure Bash coreutils

These headers correspond to their coreutils command. These really should not be used unless you don't have (for whatever reason) access to said commands. Most of these headers implement some flags/options, but not all.

| Command | Missing features | Included features |
|---------|------------------|-------------------|
| `cat.sh`| `-A -b -e -s -t -T -v` | `-n -E` |
| `sleep.sh`| Decimal `s,m,h,d` due to Bash floating point | `s,m,h,d` suffix |
| `tac.sh`| Every flag | It prints lines backwards |
| `seq.sh`| `-f -w` | `-s` |
| `ls.sh` | Every flag | `-b` to print every file with quotes around |
| `uname.sh` | `-v -i -o -p` | `-a -s -n -r -m` |
| `yes.sh` | None | All |
| `basename.sh` | `-s` | `-z` |
| `whoami.sh` | None | All |
| `fold.sh` | `-b -s` | `-w` |
