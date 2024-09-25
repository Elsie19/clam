use cmd_lib::run_cmd;
use std::os::unix::fs::PermissionsExt;
use std::{fs, path::Path, process::Command};
use which::which;

use crate::{
    config::{Config, Lock, Package},
    emsg, msg,
};

/// Compile a project
pub fn compile<S: AsRef<str>>(
    release: bool,
    conf: &Config,
    lock: &Lock,
    version: S,
) -> std::io::Result<()> {
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

    let include_paths: Vec<String> = lock
        .packages
        .iter()
        .map(|pkg| format!("-I../.deps/{}-{}", pkg.name, pkg.version))
        .collect();

    let ver_to_str = version.as_ref();

    if let Err(e) = run_cmd!(cd src/; bash_preproc -n main.sh -o ../$builddir/main.sh -v $ver_to_str -- $[include_paths])
    {
        emsg!("Could not run preprocessor: `{}`", e);
        std::process::exit(2);
    }

    let name = Path::new(&conf.name).with_extension("bin");

    fs::rename(builddir.join("main.sh"), builddir.join(&name)).unwrap();

    if release {
        Command::new("shfmt")
            .current_dir(&builddir)
            .args(["-mn", "-w", name.to_str().unwrap()])
            .output()?;
        //FIX: This is a problem with bashc where it will explode on itself unless called from it's
        //absolute path, sooooooooo...
        let res = which("bashc").expect("Could not find bashc binary");
        Command::new(res)
            .current_dir(&builddir)
            .args([name.to_str().unwrap(), &conf.name])
            .output()?;
        fs::remove_file(builddir.join(&name))?;
    } else {
        fs::rename(builddir.join(&name), builddir.join(&conf.name))?;
        let meta = fs::metadata(builddir.join(&conf.name)).unwrap();
        let mut perms = meta.permissions();

        perms.set_mode(perms.mode() | 0o100);
        fs::set_permissions(builddir.join(&conf.name), perms).unwrap();
    };

    msg!("Compiled `{}`", &conf.name);

    Ok(())
}
