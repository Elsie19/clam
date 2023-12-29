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

# bats test_tags=flag, stdin
@test "wc lines on self" {
    source wc.sh
    assert_equal "$(cat wc.sh | cmds.wc -l)" "$(cat wc.sh | wc -l)"
}

# bats test_tags=flag
@test "wc lines" {
    source wc.sh
    assert_equal "$(cmds.wc -l wc.sh)" "$(wc -l wc.sh)"
}

# bats test_tags=flag, stdin
@test "wc lines on self with <" {
    source wc.sh
    assert_equal "$(cmds.wc -l < wc.sh)" "$(wc -l < wc.sh)"
}

# bats test_tags=flag, stdin
@test "wc words on self" {
    source wc.sh
    assert_equal "$(cat wc.sh | cmds.wc -w)" "$(cat wc.sh | wc -w)"
}

# bats test_tags=flag
@test "wc words" {
    source wc.sh
    assert_equal "$(cmds.wc -w wc.sh)" "$(wc -w wc.sh)"
}

# bats test_tags=flag, stdin
@test "wc chars on self" {
    source wc.sh
    assert_equal "$(cat wc.sh | cmds.wc -c)" "$(cat wc.sh | wc -c)"
}

# bats test_tags=flag
@test "wc chars" {
    source wc.sh
    assert_equal "$(cmds.wc -c wc.sh)" "$(wc -c wc.sh)"
}

# bats test_tags=flag, stdin
@test "wc no newline empty line with stdin" {
    source wc.sh
    assert_equal "$(echo -n '' | cmds.wc -l)" "$(echo -n '' | wc -l)"
}

# bats test_tags=flag, stdin
@test "wc no newline empty word with stdin" {
    source wc.sh
    assert_equal "$(echo -n '' | cmds.wc -w)" "$(echo -n '' | wc -w)"
}

# bats test_tags=flag, stdin
@test "wc no newline single char with stdin" {
    source wc.sh
    assert_equal "$(echo -n 'k' | cmds.wc -c)" "$(echo -n 'k' | wc -c)"
}

# bats test_tags=flag, stdin
@test "wc no newline empty char with stdin" {
    source wc.sh
    assert_equal "$(echo -n '' | cmds.wc -c)" "$(echo -n '' | wc -c)"
}

# bats test_tags=flag, stdin
@test "wc no newline with stdin" {
    source wc.sh
    assert_equal "$(echo -n 'x y' | cmds.wc -l)" "$(echo -n 'x y' | wc -l)"
}

# bats test_tags=flag, stdin
@test "wc empty line with stdin" {
    source wc.sh
    assert_equal "$(echo '' | cmds.wc -l)" "$(echo '' | wc -l)"
}

# bats test_tags=flag, stdin
@test "wc empty word with stdin" {
    source wc.sh
    assert_equal "$(echo '' | cmds.wc -w)" "$(echo '' | wc -w)"
}

# bats test_tags=flag, stdin
@test "wc single char with stdin" {
    source wc.sh
    assert_equal "$(echo 'k' | cmds.wc -c)" "$(echo 'k' | wc -c)"
}

# bats test_tags=flag, stdin
@test "wc empty char with stdin" {
    source wc.sh
    assert_equal "$(echo '' | cmds.wc -c)" "$(echo '' | wc -c)"
}
