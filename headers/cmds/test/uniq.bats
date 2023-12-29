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

@test "uniq with file argument" {
    source uniq.sh
    assert_equal "$(cmds.uniq test/uniq.sample)" "$(uniq test/uniq.sample)"
}

@test "piped file into uniq" {
    source uniq.sh
    assert_equal "$(cat test/uniq.sample | cmds.uniq)" "$(cat test/uniq.sample | uniq)"
}

@test "uniq with -i" {
    source uniq.sh
    assert_equal "$(cmds.uniq -i test/uniq.sample)" "$(uniq -i test/uniq.sample)"
}

@test "uniq with -w" {
    source uniq.sh
    assert_equal "$(cmds.uniq -w 2 test/uniq.sample)" "$(uniq -w 2 test/uniq.sample)"
    assert_equal "$(cmds.uniq -w 3 test/uniq.sample)" "$(uniq -w 3 test/uniq.sample)"
}

@test "uniq with -i and -w" {
    source uniq.sh
    assert_equal "$(cmds.uniq -i -w 2 test/uniq.sample)" "$(uniq -i -w 2 test/uniq.sample)"
    assert_equal "$(cmds.uniq -i -w 3 test/uniq.sample)" "$(uniq -i -w 3 test/uniq.sample)"
}
