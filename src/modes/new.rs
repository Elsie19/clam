use std::{
    collections::HashMap,
    fs::{self, File},
    io::Write,
    os::unix::fs::PermissionsExt,
    path::PathBuf,
    process::Command,
};

use crate::config::Config;

const SHELLCHECK: &str = r#"enable=require-variable-braces
enable=require-double-brackets
"#;
const MAINSH: &str = r#"#!/bin/bash

echo 'Hello world!'

# vim:set ft=sh ts=4 sw=4 et:
"#;

pub fn new_project<S: AsRef<str>>(name: S) -> std::io::Result<()> {
    let name = name.as_ref();

    fs::create_dir(name)?;

    let proj_path: PathBuf = name.into();

    let mut tomlfile = File::create(proj_path.join("clam.toml"))?;

    tomlfile.write_all(
        toml::to_string_pretty(&Config {
            name: name.to_string(),
            ..Default::default()
        })
        .unwrap()
        .as_bytes(),
    )?;

    let mut shellfile = File::create(proj_path.join(".shellcheckrc"))?;

    shellfile.write_all(SHELLCHECK.as_bytes())?;

    let mut gitignore = File::create(proj_path.join(".gitignore"))?;

    gitignore.write_all(b"build/\n.deps/\n")?;

    fs::create_dir(proj_path.join("src/"))?;
    fs::create_dir(proj_path.join(".deps/"))?;

    let mut mainsh = File::create(proj_path.join("src").join("main.sh"))?;

    mainsh.write_all(MAINSH.as_bytes())?;

    let meta = fs::metadata(proj_path.join("src").join("main.sh"))?;
    let mut perms = meta.permissions();

    perms.set_mode(perms.mode() | 0o100);

    fs::set_permissions(proj_path.join("src").join("main.sh"), perms)?;

    let _ = Command::new("git")
        .args(["init", proj_path.to_str().unwrap()])
        .output()
        .expect("Could not run git init");

    let _ = Command::new("git")
        .args(["init", proj_path.to_str().unwrap()])
        .output()
        .expect("Could not run git init");

    let _ = Command::new("git")
        .current_dir(proj_path)
        .args(["add", "."])
        .output()
        .expect("Could not run git add");

    Ok(())
}
