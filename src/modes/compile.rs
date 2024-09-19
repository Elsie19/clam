use std::{fs, path::Path, process::Command};

use crate::msg;

/// Compile a project
pub fn compile<S: AsRef<str>>(release: bool, version: S) -> std::io::Result<()> {
    if !Path::new("src").join("main.sh").exists() {
        msg!("No file `src/main.sh` found!");
        std::process::exit(1);
    }

    let builddir = if release {
        Path::new("build").join("release/")
    } else {
        Path::new("build").join("debug/")
    };

    fs::create_dir(&builddir)?;

    let _ = Command::new("bash_preproc")
        .current_dir("src/")
        .args([
            "main.sh",
            format!("../{}/main.sh", builddir.to_str().unwrap()).as_str(),
            version.as_ref(),
        ])
        .output()
        .expect("Could not compile");

    Ok(())
}
