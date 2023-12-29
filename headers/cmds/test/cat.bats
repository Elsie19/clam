setup() {
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../src:$PATH"
}

@test "cat" {
    source cat.sh
    [[ $(cat cat.sh) == "$(cmds.cat cat.sh)" ]]
}

@test "cat -E" {
    source cat.sh
    [[ $(cat -E cat.sh) == "$(cmds.cat -E cat.sh)" ]]
}

@test "cat -n" {
    source cat.sh
    [[ $(cat -n cat.sh) == "$(cmds.cat -n cat.sh)" ]]
}
