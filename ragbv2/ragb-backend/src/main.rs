mod model;
mod route;
mod handler;
mod authorization;

use route::create_router;

#[tokio::main]
async fn main() {
    println!("🚀 Server started successfully");
    let listener = tokio::net::TcpListener::bind("127.0.0.1:9999").await.unwrap();
    let app = create_router();
    axum::serve(listener, app).await.unwrap();
}
