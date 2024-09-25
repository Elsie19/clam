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
        ///
        /// This will inject your project into a statically compiled bash binary, so be weary of
        /// the output size.
        #[clap(short, long)]
        release: bool,
    },

    /// Format project
    ///
    /// Format project files with sane defaults.
    Fmt {},

    /// Run project
    ///
    /// Compile and run project.
    Run {},

    /// Generate docs
    ///
    /// Generate docs using shdoc.
    Docs {},

    #[command(subcommand)]
    Dep(DepCommands),
}

#[derive(Subcommand, Debug)]
/// Handle dependencies
///
/// Add, remove, update, or pull down dependencies.
pub enum DepCommands {
    /// Add a dependency
    Add {
        /// URL to add
        url: String,
        /// Name to add as
        #[clap(short, long)]
        name: Option<String>,
        /// Version to add
        #[clap(short, long)]
        version: Option<String>,
    },
    /// Remove a dependency by name
    Remove {
        /// Name of package to remove
        name: String,
    },
    /// Pull dependencies
    Pull {},
    /// List dependencies of project
    List {},
}
