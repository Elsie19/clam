setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../src:$PATH"
}

@test "wc lines" {
    source wc.sh
    assert_equal "$(cat wc.sh | cmds.wc -l)" "$(cat wc.sh | wc -l)"
}

@test "wc words" {
    source wc.sh
    assert_equal "$(cat wc.sh | cmds.wc -w)" "$(cat wc.sh | wc -w)"
}

@test "wc chars" {
    source wc.sh
    assert_equal "$(cat wc.sh | cmds.wc -c)" "$(cat wc.sh | wc -c)"
}
