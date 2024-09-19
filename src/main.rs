mod config;
mod flags;
mod msg;
mod modes {
    pub mod compile;
    pub mod new;
}

use clap::Parser;
use config::Config;
use flags::Args;
use modes::new::new_project;

fn main() {
    let cli = Args::parse();

    match cli.cmd {
        flags::Commands::New { name } => {
            new_project(&name).unwrap();
            msg!("Created application `{}`", name);
        }
        flags::Commands::Compile { release } => {
            let conf = match std::fs::read_to_string("clam.toml") {
                Ok(o) => o,
                Err(e) => {
                    eprintln!("{e}");
                    std::process::exit(1);
                }
            };

            let config: Config = match toml::from_str(&conf) {
                Ok(o) => o,
                Err(e) => {
                    eprintln!("{e}");
                    std::process::exit(1);
                }
            };
            dbg!(config);
        }
    };
}
