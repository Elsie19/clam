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

# bats test_tags=interactive
@test "ls interactive" {
    # We have to do that so we trick ls into thinking it's in a tty and
    # not in a terminal
    assert_equal "$(unbuffer bash -c 'source ls.sh && cmds.ls')" "$(unbuffer ls)"
}

# bats test_tags=flag
@test "ls -1" {
    source ls.sh
    assert_equal "$(cmds.ls -1)" "$(ls -1)"
}

# bats test_tags=flag, interactive
@test "ls -m interactive" {
    assert_equal "$(unbuffer bash -c 'source ls.sh && cmds.ls -m')" "$(unbuffer ls -m)"
}

# bats test_tags=flag, interactive
@test "ls -1m interactive" {
    assert_equal "$(unbuffer bash -c 'source ls.sh && cmds.ls -1m')" "$(unbuffer ls -1m)"
}

# bats test_tags=flag
@test "ls -1m" {
    assert_equal "$(cmds.ls -1m)" "$(ls -1m)"
}
