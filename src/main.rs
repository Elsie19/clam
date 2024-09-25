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
use cmd_lib::{run_cmd, run_fun, spawn_with_output};
use colored::Colorize;
use config::{Config, Lock};
use flags::{Args, DepCommands};
use modes::{
    compile::compile, dep::add_dep, dep::pull_deps, fmt::format_project, new::new_project,
};

fn main() {
    // I dislike [`cmd_lib`] and it's stupidness
    std::env::set_var("RUST_LOG", "OFF");
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
            let Ok(lock) = std::fs::read_to_string("clam.lock") else {
                emsg!("Run `clam dep pull` first!");
                std::process::exit(1);
            };
            let lock: Lock = match toml::from_str(&lock) {
                Ok(o) => o,
                Err(e) => {
                    emsg!("{e}");
                    std::process::exit(1);
                }
            };
            compile(release, &config, &lock, env!("CARGO_PKG_VERSION")).unwrap();
        }
        flags::Commands::Fmt {} => {
            format_project().unwrap();
        }
        flags::Commands::Docs {} => todo!(),
        flags::Commands::Run {} => {
            let Ok(lock) = std::fs::read_to_string("clam.lock") else {
                emsg!("Run `clam dep pull` first!");
                std::process::exit(1);
            };
            let lock: Lock = match toml::from_str(&lock) {
                Ok(o) => o,
                Err(e) => {
                    emsg!("{e}");
                    std::process::exit(1);
                }
            };
            match compile(false, &config, &lock, env!("CARGO_PKG_VERSION")) {
                Ok(()) => {}
                Err(e) => {
                    eprintln!("{e}");
                    std::process::exit(1);
                }
            }
            println!(
                "\n===[ {} {} ]===\n",
                "Running".green(),
                config.name.green()
            );

            let form = format!("time ./build/debug/{}", config.name);
            let out = run_cmd!(bash -c $form);
            println!(
                "Exited with error code: {}",
                match out {
                    Ok(()) => "0".to_string(),
                    Err(e) => format!("{}", e),
                }
            );
            println!("\n===[ Finished {} ]===\n", config.name);
        }
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
            DepCommands::Pull {} => pull_deps(&config).unwrap(),
            DepCommands::List {} => {
                for pkg in config.dependencies {
                    println!(
                        "{} ~ {}",
                        pkg.0,
                        match pkg.1 {
                            config::Dependency::Simple(_) => "null".to_string(),
                            config::Dependency::Versioned { url, ver } => match ver {
                                Some(o) => o,
                                None => "null".to_string(),
                            },
                        }
                    );
                }
            }
        },
    };
}
