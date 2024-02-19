use crate::model::{DMXArray, DMXAtom, DMXColor, DB};
use axum::{
    debug_handler,
    extract::{Path, State},
    http::StatusCode,
    response::{sse::Event, IntoResponse, Sse},
    Extension, Json,
};
use std::time::{Duration, Instant};
use tokio_stream::StreamExt;
use tokio_stream::{self as stream};

#[debug_handler]
pub async fn healthcheck_handler() -> impl IntoResponse {
    StatusCode::OK
}

#[debug_handler]
pub async fn list_values_handler(State(db): State<DB>) -> impl IntoResponse {
    let val;
    {
        let lock = db.mut_state.read().await;
        val = lock.dmx.clone();
    }
    Json(val)
}

#[debug_handler]
pub async fn batch_edit_value_handler(
    State(db): State<DB>,
    //Extension(user): Extension<String>,
    Json(body): Json<Vec<DMXAtom>>,
) -> Result<(), StatusCode> {
    let mut lock = db.mut_state.write().await;
    //if lock.ratelimit_info[&user].elapsed() > Duration::from_secs(1) {
    //    return Err(StatusCode::
    for i in &body {
        check_id(i.address, &lock.dmx)?;
    }
    for i in &body {
        lock.dmx[i.address] = i.value;
        match db.static_state.color_change_channel.send(*i) {
            Ok(_) => (),
            Err(_) => (),
        }
    }
    //lock.ratelimit_info.insert(user, Instant::now());

    Ok(())
}

#[debug_handler]
pub async fn get_value_handler(
    Path(id): Path<usize>,
    State(db): State<DB>,
) -> Result<impl IntoResponse, StatusCode> {
    let lock = db.mut_state.read().await;
    check_id(id, &lock.dmx)?;
    Ok(Json(lock.dmx[id]))
}

#[debug_handler]
pub async fn edit_value_handler(
    Path(id): Path<usize>,
    State(db): State<DB>,
    Json(body): Json<DMXColor>,
) -> Result<(), StatusCode> {
    let mut lock = db.mut_state.write().await;
    check_id(id, &lock.dmx)?;
    lock.dmx[id] = body;
    match db
        .static_state
        .color_change_channel
        .send(DMXAtom::new(id, body))
    {
        Ok(_) => (),
        Err(_) => (),
    };

    Ok(())
}

#[debug_handler]
pub async fn sse_handler(State(db): State<DB>) -> impl IntoResponse {
    let rx = db.static_state.color_change_channel.subscribe();
    let data: Vec<DMXColor>;
    {
        let lock = db.mut_state.read().await;
        data = lock.dmx.clone();
    }
    let init_data = data.into_iter().enumerate().map(|(i, x)| {
        Ok(DMXAtom {
            address: i,
            value: x,
        })
    });
    let init = stream::iter(init_data);
    let stream = init
        .chain(stream::wrappers::BroadcastStream::new(rx))
        .filter_map(|item| match item {
            Ok(val) => Some(Event::default().json_data(val)),
            Err(_) => None,
        });

    Sse::new(stream).keep_alive(
        axum::response::sse::KeepAlive::new()
            .interval(Duration::from_secs(25))
            .text("ping"),
    )
}

fn check_id(id: usize, val: &DMXArray) -> Result<(), StatusCode> {
    if id >= val.len() {
        return Err(StatusCode::NOT_FOUND);
    };
    Ok(())
}
