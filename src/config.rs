use std::collections::HashMap;

use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize, Debug, Default, Clone)]
pub struct Config {
    pub name: String,
    pub dependencies: HashMap<String, Dependency>,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
#[serde(untagged)]
pub enum Dependency {
    Versioned { url: String, ver: Option<String> },
    Simple(String),
}

#[derive(Deserialize, Serialize, Debug, Default, Clone)]
pub struct Lock {
    pub version: i64,
    pub packages: Vec<Package>,
}

#[derive(Deserialize, Serialize, Debug, Default, Clone)]
pub struct Package {
    pub name: String,
    pub version: String,
    pub source: String,
}

impl Dependency {
    pub fn get_url(&self) -> String {
        match self {
            Self::Simple(u) => u.to_string(),
            Self::Versioned { url, .. } => url.to_string(),
        }
    }
}
