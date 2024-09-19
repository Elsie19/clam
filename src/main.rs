mod config;
mod flags;
mod msg;
mod modes {
    pub mod compile;
    pub mod fmt;
    pub mod new;
}

use clap::Parser;
use config::Config;
use flags::Args;
use modes::{compile::compile, fmt::format_project, new::new_project};

fn main() {
    let cli = Args::parse();

    match cli.cmd {
        flags::Commands::New { name } => {
            new_project(&name).unwrap();
            msg!("Created application `{}`", name);
        }
        flags::Commands::Compile { release } => {
            let Ok(conf) = std::fs::read_to_string("clam.toml") else {
                emsg!("Could not read file `clam.toml`");
                std::process::exit(1);
            };

            let config: Config = match toml::from_str(&conf) {
                Ok(o) => o,
                Err(e) => {
                    emsg!("{e}");
                    std::process::exit(1);
                }
            };
            compile(release, &config, env!("CARGO_PKG_VERSION")).unwrap();
        }
        flags::Commands::Fmt {} => {
            format_project().unwrap();
        }
    };
}
