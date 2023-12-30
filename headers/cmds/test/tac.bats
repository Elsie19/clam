setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" > /dev/null 2>&1 && pwd)"
    # make executables in src/ visible to PATH
    PATH="$DIR/../src:$PATH"
}

@test "tac with file argument" {
    source tac.sh
    assert_equal "$(cmds.tac tac.sh)" "$(tac tac.sh)"
}

# bats test_tags=stdin
@test "tac with stdin" {
    source tac.sh
    assert_equal "$(cat tac.sh | cmds.tac)" "$(cat tac.sh | tac)"
}
