use dotenvy;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::str::FromStr;
use std::sync::Arc;
use std::time::Instant;
use tokio::sync::{broadcast, RwLock};

#[derive(Debug, Deserialize, Serialize, Copy, Clone)]
pub struct DMXColor {
    pub red: u8,
    pub green: u8,
    pub blue: u8,
}

pub type DMXArray = Vec<DMXColor>;

#[derive(Debug, Deserialize, Serialize, Copy, Clone)]
pub struct DMXAtom {
    pub address: usize,
    pub value: DMXColor,
}

impl DMXAtom {
    pub fn new(address: usize, value: DMXColor) -> DMXAtom {
        DMXAtom { address, value }
    }
}

pub struct AppState {
    pub dmx: DMXArray,
    pub ratelimit_info: HashMap<String, Instant>,
}

impl AppState {
    pub fn new(size: usize) -> AppState {
        AppState {
            dmx: vec![
                DMXColor {
                    red: 0,
                    green: 0,
                    blue: 0,
                };
                size
            ],
            ratelimit_info: HashMap::new(),
        }
    }
}

pub struct StaticState {
    pub jwt_key: String,
    pub color_change_channel: broadcast::Sender<DMXAtom>,
}

pub struct SharedState {
    pub static_state: StaticState,
    pub mut_state: RwLock<AppState>,
}

pub type DB = Arc<SharedState>;

pub fn make_db() -> DB {
    let state_size: usize =
        usize::from_str(&dotenvy::var("NB_DMX_VALUES").unwrap_or(String::from("100"))).unwrap();
    Arc::new(SharedState {
        static_state: StaticState {
            jwt_key: dotenvy::var("JWT_SECRET").unwrap_or(String::from("secret")),
            color_change_channel: broadcast::Sender::new(16),
        },
        mut_state: RwLock::new(AppState::new(state_size)),
    })
}
