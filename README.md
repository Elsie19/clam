# Clam

<p align="center">
<a href="https://github.com/Elsie19/clam"><img align="center" src="https://webstockreview.net/images/clam-clipart-svg-10.png" width="200" height="200"></a>
</p>

<p align="center"><b>A programming environment for shell scripts</b></p>

### Features
* Header files with [bash_preproc](https://github.com/Elsie19/bash_preproc)
* Macro system
* Documentation generation with [shdoc](https://github.com/reconquest/shdoc)
* Enforced, objective formatting with `shfmt`
* Shellcheck to prevent potentially broken code from running
* Creates binaries from your code with `shc`

### Getting started
First, download [bash_preproc](https://github.com/Elsie19/bash_preproc) and [shdoc](https://github.com/reconquest/shdoc). Then download Clam with `sudo make install`. To create a project, run `clam new {name}`. You can edit `src/main.sh` as you want, and when you want to compile your project, run `clam compile` in the root of your project. You can also use `clam run` to run your project after compiling.

If your code ever gets too messy, and you want to format it, run `clam fmt`.

#### Headers
If you want to separate your code into libraries, you can use Clam's header capabilities (provided by bash_preproc). Standard headers are located in `/usr/include/bash/`, but you can use local headers.

Headers take two forms:
```bash
#include <global.sh>

#include "local.sh"
```

The `<>` and `""` denote whether you want to use global headers or local headers, respectively. Local headers should be added to the `src/` directory.

File tree:
```bash
.
└── src
    ├── main.sh
    └── msg.sh
```

Contents of `main.sh`:
```bash
#!/bin/bash

#include "msg.sh"

msg 'Hello world!'
```

Contents of `msg.sh`:
```bash
#!/bin/bash

function msg() {
    echo -e "> $*"
}
```

When compiled, the final file before being turned into a binary will look like this:
```bash
#!/bin/bash

function msg() {
    echo -e "> $*"
}

msg 'Hello world!'
```

<details>

<summary>Click for more info on what you can do with the preprocessor!</summary>

##### Defining constants

You can define constants with the `#define` header just as you can in C/C++, however in Clam, you cannot use a `$` to prefix something, as in this example:

```bash
#define FOO bar

echo $FOO
# Prints: $bar
```

So make sure your chosen names will absolutely not clash with anything. You can also `#undef` something.

##### Conditionals

Everything from C/C++ applies here.

##### Compile-time

You may run commands during "compilation" with the `#exec` header.

You may also hardcode the filename with `#file` and any given line number with `#line`.

##### Errors and warnings

You may issue warnings and errors with the `#warning` and `#error` headers.

</details>



#### Macros

Clam utilizes `bash_preproc` which features a macro system. Initialize a macro like so:

```bash
#define MULT{x y} $((x * y))

echo MULT{5 6}
# Prints 30
```

More advanced features for the macro system include:

* Named arguments with `$<num>`

#### Doc generation
Familiarize yourself with how to use [shdoc](https://github.com/reconquest/shdoc#features) first. When you are done creating your definitions, run `clam docs` to create markdown files with all your definitions in `docs/${file}.md`.
