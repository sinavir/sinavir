use crate::authorization::jwt_middleware;
use crate::authorization::User;
use crate::handler;
use crate::model;
use axum::extract::{Request, State};
use axum::{handler::Handler, middleware};
use axum::{http::StatusCode, routing::get, Router};
use axum_extra::{headers, typed_header::TypedHeader};
use serde::{Deserialize, Serialize};
use std::time::Duration;
use tower::ServiceBuilder;
use tower_governor::{
    errors::GovernorError, governor::GovernorConfigBuilder, key_extractor::KeyExtractor,
    GovernorLayer,
};
use tower_http::cors::{Any, CorsLayer};

#[derive(Debug, Serialize, Deserialize, Clone, Eq, PartialEq)]
struct UserExtension;

impl KeyExtractor for UserExtension {
    type Key = User;

    fn extract<B>(&self, req: &Request<B>) -> Result<Self::Key, GovernorError> {
        req.extensions()
            .get::<User>()
            .map(|user| user.clone())
            .ok_or(GovernorError::UnableToExtractKey)
    }
}

pub fn create_router() -> Router {
    let db = model::make_db();
    let cors = CorsLayer::new()
        // allow requests from any origin
        .allow_origin(Any)
        .allow_headers(Any);
    let governor_conf = Box::new(
        GovernorConfigBuilder::default()
            .per_second(1)
            .burst_size(2)
            .key_extractor(UserExtension)
            .finish()
            .unwrap(),
    );

    let governor_limiter = governor_conf.limiter().clone();
    let service = ServiceBuilder::new()
        .layer(middleware::from_fn_with_state::<
            _,
            model::DB,
            (
                State<model::DB>,
                TypedHeader<headers::Authorization<headers::authorization::Bearer>>,
                Request,
            ),
        >(db.clone(), jwt_middleware))
        .layer(GovernorLayer {
            config: Box::leak(governor_conf),
        });

    let interval = Duration::from_secs(60);
    std::thread::spawn(move || loop {
        std::thread::sleep(interval);
        println!("  rate limiting storage size: {}", governor_limiter.len());
        governor_limiter.retain_recent();
    });

    Router::new()
        .route("/api/healthcheck", get(handler::healthcheck_handler))
        .route(
            "/api/values",
            get(handler::list_values_handler)
                .post(handler::batch_edit_value_handler.layer(service)),
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
