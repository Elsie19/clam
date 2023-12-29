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

@test "seq with one argument" {
    source seq.sh
    assert_equal "$(cmds.seq 4)" "$(seq 4)"
}

@test "seq with one argument (0)" {
    source seq.sh
    assert_equal "$(cmds.seq 0)" "$(seq 0)"
}

@test "seq with lower and upper limit" {
    source seq.sh
    assert_equal "$(cmds.seq 3 42)" "$(seq 3 42)"
}

@test "seq with negative lower and upper limit" {
    source seq.sh
    assert_equal "$(cmds.seq -- -3 42)" "$(seq -3 42)"
}

@test "seq with limit and custom increment" {
    source seq.sh
    assert_equal "$(cmds.seq 0 5 20)" "$(seq 0 5 20)"
}

# bats test_tags=flag
@test "seq with one argument with seperator" {
    source seq.sh
    assert_equal "$(cmds.seq -s "!" 4)" "$(seq -s "!" 4)"
}

# bats test_tags=flag
@test "seq with one argument (0) with seperator" {
    source seq.sh
    assert_equal "$(cmds.seq -s ':' 0)" "$(seq -s ':' 0)"
}

# bats test_tags=flag
@test "seq with lower and upper limit with seperator" {
    source seq.sh
    assert_equal "$(cmds.seq -s "*" 3 42)" "$(seq -s "*" 3 42)"
}

# bats test_tags=flag
@test "seq with negative lower and upper limit with seperator" {
    source seq.sh
    assert_equal "$(cmds.seq -s "^" -- -3 42)" "$(seq -s "^" -3 42)"
}

# bats test_tags=flag
@test "seq with limit and custom increment with seperator with seperator" {
    source seq.sh
    assert_equal "$(cmds.seq -s "$" 0 5 20)" "$(seq -s "$" 0 5 20)"
}
