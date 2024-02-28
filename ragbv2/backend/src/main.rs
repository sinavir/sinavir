mod authorization;
mod handler;
mod model;
mod route;

use dotenvy;
use route::create_router;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};
use tower_http::trace::TraceLayer;

#[tokio::main]
async fn main() {
    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env().unwrap_or_else(|_| {
                "info,axum::rejection=trace".into()
            }),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();
    match dotenvy::dotenv() {
        Err(_) => tracing::info!(".env file not found"),
        _ => (),
    }

    let binding = dotenvy::var("BIND").unwrap_or(String::from("127.0.0.1:9999"));
    let bind = binding.trim();
    tracing::debug!("Trying to bind at {bind}");
    let listener = tokio::net::TcpListener::bind(bind).await.unwrap();
    let app = create_router()
        .layer(
            TraceLayer::new_for_http()
        );
    tracing::info!("🚀 Server started successfully");
    axum::serve(listener, app).await.unwrap();
}
