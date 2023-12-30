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

@test "cat" {
    source cat.sh
    assert_equal "$(cmds.cat cat.sh)" "$(cat cat.sh)"
}

# bats test_tags=flag
@test 'cat -E (ending with $ symbol)' {
    source cat.sh
    assert_equal "$(cmds.cat -E cat.sh)" "$(cat -E cat.sh)"
}

# bats test_tags=flag
@test "cat -n (numbers lines)" {
    source cat.sh
    assert_equal "$(cmds.cat -n cat.sh)" "$(cat -n cat.sh)"
}

# bats test_tags=flag
@test "cat -En" {
    source cat.sh
    assert_equal "$(cmds.cat -En cat.sh)" "$(cat -En cat.sh)"
}
