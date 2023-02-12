### Clam standard headers

These headers are included with every version of Clam.

Headers are generally grouped together into one meta-header, just like meta-packages. You should use those if said meta-header contains functionality you want instead of including it's headers by themselves.

| Name 	       | Usage     | Meta-header|
|--------------|-----------|------------|
| `stdout.sh`  | Used for all fancy output needs | ✔️ |
| `colors.sh`  | Implements a variety of colors + `$NO_COLOR` support | ❌ |
| `msg.sh`     | Implements visually pleading output | ❌ |
