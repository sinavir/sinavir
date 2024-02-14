mod authorization;
mod handler;
mod model;
mod route;

use dotenvy;
use route::create_router;

#[tokio::main]
async fn main() {
    match dotenvy::dotenv() {
        Err(_) => println!("⚠️  .env file not found"),
        _ => (),
    }
    let bind = dotenvy::var("BIND").unwrap_or(String::from("127.0.0.1:9999"));
    println!(".. Trying to bind at {bind}");
    let listener = tokio::net::TcpListener::bind(bind).await.unwrap();
    let app = create_router();
    println!("🚀 Server started successfully");
    axum::serve(listener, app).await.unwrap();
}
