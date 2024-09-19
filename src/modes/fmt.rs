use std::{fs, path::Path, process::Command};

use crate::{emsg, msg};

pub fn format_project() -> std::io::Result<()> {
    if !Path::new("src").join("main.sh").exists() {
        emsg!("No file `src/main.sh` found!");
        std::process::exit(1);
    }

    let mut yas: Vec<String> = ["-bn", "-ci", "-sr", "-i", "4", "-w"]
        .iter()
        .map(|&s| s.to_string())
        .collect();

    let mut files: Vec<String> = vec![];

    for f in fs::read_dir("src/")? {
        let entr = f?;
        let path = entr.path();

        if path.is_file() && path.extension() == Some("sh".as_ref()) {
            files.push(path.to_str().unwrap().to_string());
        }
    }

    yas.extend(files.clone());
    Command::new("shfmt").args(yas).output()?;

    msg!("Done formatting {}", files.join(", "));

    Ok(())
}
