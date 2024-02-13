use crate::model::DB;
use axum::{
    http::StatusCode,
    extract::{Request, State},
    middleware::Next,
    response::Response,
};
use axum_extra::{headers, typed_header::TypedHeader};

fn check_token(token: &str, jwt: &str) -> bool {
    if cfg!(debug_assertions)  {
        return token == "test";
    }
    true
}

pub async fn jwt_middleware(
    State(state): State<DB>,
    TypedHeader(auth): TypedHeader<headers::Authorization<headers::authorization::Bearer>>,
    request: Request,
    next: Next,
) -> Result<Response, StatusCode> {
    let token = auth.token();
    if check_token(token, &state.static_state.jwt_key) {
      Ok(next.run(request).await)
    } else {
        Err(StatusCode::FORBIDDEN)
    }
}
