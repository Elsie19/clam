use cmd_lib::{run_cmd, run_fun};
use core::str;
use std::{
    fs::{self, create_dir_all, File},
    io::Write,
    path::Path,
};

use crate::{
    config::{Config, Dependency, Lock, Package},
    emsg,
};

pub fn add_dep<S: AsRef<str>>(url: &S, name: &Option<S>, version: &Option<S>, config: &mut Config) {
    let actual_version = if let Some(o) = version.as_ref() {
        o.as_ref()
    } else {
        let url_str = url.as_ref();
        &run_fun!(git -c versionsort.suffix=- ls-remote --tags --refs --sort=version:refname ${url_str} | awk -F/ r#"END{print$NF}"#).unwrap()
    };

    config.dependencies.insert(
        if let Some(name) = name {
            name.as_ref().to_string()
        } else {
            let path = Path::new(url.as_ref());
            path.file_name().unwrap().to_str().unwrap().to_string()
        },
        Dependency::Versioned {
            url: url.as_ref().to_string(),
            ver: Some(actual_version.to_string()),
        },
    );
}

pub fn pull_deps(conf: &Config) -> std::io::Result<()> {
    create_dir_all(".deps/")?;

    let mut lockfile = Lock {
        version: 1,
        packages: vec![],
    };

    for (depname, co) in &conf.dependencies {
        println!("Downloading '{}'...", &depname);

        let args: Vec<String> = match co {
            Dependency::Simple(u) => [u.to_string()].to_vec(),
            Dependency::Versioned { url, ver } => [
                "--branch".to_string(),
                ver.as_ref().unwrap().to_string(),
                url.to_string(),
            ]
            .to_vec(),
        };

        match run_cmd!(
            cd .deps/;
            rm -rf tmp_dl;
            git clone -q --depth=1 $[args] tmp_dl 2>/dev/null
        ) {
            Ok(o) => o,
            Err(e) => {
                eprintln!(
                    ">>> Could not download dependency for reason '{}'. Skipping...",
                    e
                );
                continue;
            }
        };
        println!("    >> Retrieving version...");
        let commit = run_fun!(
            cd .deps/tmp_dl;
            git rev-parse HEAD
        )
        .unwrap()
        .trim()
        .to_string();

        let new_dir = format!(".deps/{depname}-{commit}/{depname}");
        if let Err(e) = fs::create_dir_all(&new_dir) {
            emsg!("Could not create '{new_dir}': '{e}'");
            std::process::exit(1);
        }

        // We don't care if it exists already, we yoink it either way.
        let _ = fs::remove_dir_all(&new_dir);
        std::fs::rename(".deps/tmp_dl", new_dir).unwrap();

        lockfile.packages.push(Package {
            name: depname.into(),
            version: commit,
            source: co.get_url(),
        })
    }

    let mut lockfile_file = File::create("clam.lock").unwrap();

    lockfile_file
        .write_all(toml::to_string_pretty(&lockfile).unwrap().as_bytes())
        .unwrap();

    Ok(())
}
