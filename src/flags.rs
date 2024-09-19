use clap::{Parser, Subcommand};

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
#[clap(version)]
pub struct Args {
    #[command(subcommand)]
    pub cmd: Commands,
}

#[derive(Subcommand, Debug)]
pub enum Commands {
    /// Create new project
    ///
    /// Create a new project with sane defaults.
    New {
        /// Name of project
        name: String,
    },

    /// Compile project
    ///
    /// Compile a project to a single executable.
    Compile {
        /// Compile as release build
        #[clap(short, long)]
        release: bool,
    },
}
