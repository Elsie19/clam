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

@test "basename with extension and path" {
    source basename.sh
    assert_equal "$(cmds.basename /home/user/data/filename.txt)" "$(basename /home/user/data/filename.txt)"
}

@test "basename without extension but with path" {
    source basename.sh
    assert_equal "$(cmds.basename /home/user/data/filename)" "$(basename /home/user/data/filename)"
}

@test "basename with extension but without path" {
    source basename.sh
    assert_equal "$(cmds.basename .foo)" "$(basename .foo)"
}

@test "basename with partial extension and path" {
    source basename.sh
    assert_equal "$(cmds.basename dir/something thing)" "$(basename dir/something thing)"
}

@test "basename with path (/)" {
    source basename.sh
    assert_equal "$(cmds.basename /)" "$(basename /)"
}

@test "basename with path (/) and extension" {
    source basename.sh
    assert_equal "$(cmds.basename / thing)" "$(basename / thing)"
}

@test "basename removing suffix" {
    source basename.sh
    assert_equal "$(cmds.basename /home/user/data/filename.txt .txt)" "$(basename /home/user/data/filename.txt .txt)"
}

@test "basename removing suffix when none exists" {
    source basename.sh
    assert_equal "$(cmds.basename /home/user/data/filename .txt)" "$(basename /home/user/data/filename .txt)"
}

@test "basename removing suffix when none exists on directory" {
    source basename.sh
    assert_equal "$(cmds.basename /home/user/data/ .txt)" "$(basename /home/user/data/ .txt)"
}

@test "basename on weird data (/$'\\n')" {
    source basename.sh
    assert_equal "$(cmds.basename /$'\n')" "$(basename /$'\n')"
}
