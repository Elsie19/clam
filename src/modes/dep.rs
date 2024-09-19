use core::str;
use std::{
    path::Path,
    process::{Command, Stdio},
};

use crate::config::{Config, Dependency};

pub fn add_dep<S: AsRef<str>>(url: &S, name: &Option<S>, version: &Option<S>, config: &mut Config) {
    let actual_version = if let Some(o) = version.as_ref() {
        o.as_ref()
    } else {
        let git_output = Command::new("git")
            .stdout(Stdio::piped())
            .args([
                "-c",
                "versionsort.suffix=-",
                "ls-remote",
                "--tags",
                "--refs",
                "--sort=version:refname",
                url.as_ref(),
            ])
            .spawn()
            .unwrap();
        let output = Command::new("awk")
            .stdin(git_output.stdout.unwrap())
            .stdout(Stdio::piped())
            .args(["-F/", "END{print$NF}"])
            .spawn()
            .unwrap();
        let out = output.wait_with_output().unwrap();
        &str::from_utf8(&out.stdout).unwrap().to_string()
    };

    config.dependencies.insert(
        if let Some(name) = name {
            name.as_ref().to_string()
        } else {
            let path = Path::new(url.as_ref());
            path.file_name().unwrap().to_str().unwrap().to_string()
        },
        if version.is_some() {
            Dependency::Versioned {
                url: url.as_ref().to_string(),
                ver: Some(actual_version.to_string()),
            }
        } else {
            Dependency::Simple(url.as_ref().to_string())
        },
    );
}
