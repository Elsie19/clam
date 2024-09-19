use std::collections::HashMap;

use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize, Debug, Default)]
pub struct Config {
    pub name: String,
    pub dependencies: HashMap<String, Dependency>,
}

#[derive(Debug, Deserialize, Serialize)]
#[serde(untagged)]
pub enum Dependency {
    Versioned { url: String, ver: Option<String> },
    Simple(String),
}
