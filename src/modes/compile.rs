use std::{fs, path::Path, process::Command};
use which::which;

use crate::{config::Config, emsg, msg};

/// Compile a project
pub fn compile<S: AsRef<str>>(release: bool, conf: &Config, version: S) -> std::io::Result<()> {
    if !Path::new("src").join("main.sh").exists() {
        emsg!("No file `src/main.sh` found!");
        std::process::exit(1);
    }

    let builddir = if release {
        Path::new("build").join("release/")
    } else {
        Path::new("build").join("debug/")
    };

    fs::create_dir_all(&builddir)?;

    Command::new("bash_preproc")
        .current_dir("src/")
        .args([
            "main.sh",
            format!("../{}/main.sh", builddir.to_str().unwrap()).as_str(),
            version.as_ref(),
        ])
        .output()?;

    let name = Path::new(&conf.name).with_extension("bin");

    fs::rename(builddir.join("main.sh"), builddir.join(&name))?;

    if release {
        Command::new("shfmt")
            .current_dir(&builddir)
            .args(["-mn", "-w", name.to_str().unwrap()])
            .output()?;
        let res = which("bashc").expect("Could not find bashc binary");
        Command::new(res)
            .current_dir(&builddir)
            .args([name.to_str().unwrap(), &conf.name])
            .output()?;
        fs::remove_file(builddir.join(name))?;
    } else {
        fs::rename(builddir.join(&name), builddir.join(&conf.name))?;
    };

    msg!("Compiled `{}`", &conf.name);

    Ok(())
}
