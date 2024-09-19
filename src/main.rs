mod config;
mod flags;
mod msg;
mod modes {
    pub mod compile;
    pub mod dep;
    pub mod docs;
    pub mod fmt;
    pub mod new;
}

use std::{fs::File, io::Write};

use clap::Parser;
use config::Config;
use flags::{Args, DepCommands};
use modes::{compile::compile, dep::add_dep, fmt::format_project, new::new_project};

fn main() {
    let cli = Args::parse();

    let Ok(conf) = std::fs::read_to_string("clam.toml") else {
                emsg!("Could not read file `clam.toml`");
                std::process::exit(1);
            };
    let mut config: Config = match toml::from_str(&conf) {
        Ok(o) => o,
        Err(e) => {
            emsg!("{e}");
            std::process::exit(1);
        }
    };

    match cli.cmd {
        flags::Commands::New { name } => {
            new_project(&name).unwrap();
            msg!("Created application `{}`", name);
        }
        flags::Commands::Compile { release } => {
            compile(release, &config, env!("CARGO_PKG_VERSION")).unwrap();
        }
        flags::Commands::Fmt {} => {
            format_project().unwrap();
        }
        flags::Commands::Docs {} => todo!(),
        flags::Commands::Dep(o) => match o {
            DepCommands::Remove { name } => {
                if config.dependencies.remove(&name).is_some() {
                } else {
                    emsg!("No key '{}' found!", &name);
                    std::process::exit(1);
                };
                let mut file = File::create("clam.toml").unwrap();
                file.write_all(toml::to_string_pretty(&config).unwrap().as_bytes())
                    .unwrap();
            }
            DepCommands::Add { url, name, version } => {
                add_dep(&url, &name, &version, &mut config);
                let mut file = File::create("clam.toml").unwrap();
                file.write_all(toml::to_string_pretty(&config).unwrap().as_bytes())
                    .unwrap();
                msg!("Added '{}'", url);
            }
            _ => todo!(),
        },
    };
}
