use crate::authorization::jwt_middleware;
use crate::handler;
use crate::model;
use axum::{handler::Handler, middleware};
use axum::{routing::get, Router};
use serde_json::to_writer;
use std::fs::File;
use tokio::task;
use tokio::time::{sleep, Duration};
use tower_http::cors::{Any, CorsLayer};

pub fn create_router() -> Router {
    let db = model::make_db();

    let cors = CorsLayer::new()
        // allow requests from any origin
        .allow_origin(Any)
        .allow_headers(Any);
    let db_to_save = db.clone();
    task::spawn(async move {
        loop {
            sleep(Duration::from_millis(1000)).await;
            {
                let save_path = &db_to_save.static_state.save_path;
                let file = File::create(save_path);
                match file {
                    Ok(f) => {
                        let db = db_to_save.mut_state.read().await;
                        match to_writer(f, &db.dmx) {
                            Ok(()) => tracing::trace!("Saved data at {save_path}"),
                            Err(e) => {
                                tracing::debug!("Failed to save data: {e:?}");
                                ()
                            }
                        }
                    }
                    Err(e) => {
                        tracing::debug!("Failed to save data: {e:?}");
                        ()
                    }
                }
            }
        }
    });

    Router::new()
        .route("/api/healthcheck", get(handler::healthcheck_handler))
        .route(
            "/api/values",
            get(handler::list_values_handler).post(
                handler::batch_edit_value_handler
                    .layer(middleware::from_fn_with_state(db.clone(), jwt_middleware)),
            ),
        )
        .route("/api/sse", get(handler::sse_handler))
        .route(
            "/api/values/:id",
            get(handler::get_value_handler).post(
                handler::edit_value_handler
                    .layer(middleware::from_fn_with_state(db.clone(), jwt_middleware)),
            ),
        )
        .layer(cors)
        .with_state(db)
}
