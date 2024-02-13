use crate::authorization::jwt_middleware;
use crate::handler;
use crate::model;
use axum::{handler::Handler, middleware};

use axum::{routing::get, Router};

pub fn create_router() -> Router {
    let db = model::make_db();

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
        .with_state(db)
}
