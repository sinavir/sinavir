use crate::model::DB;
use axum::{
    extract::{Request, State},
    http::StatusCode,
    middleware::Next,
    response::Response,
};
use axum_extra::{headers, typed_header::TypedHeader};
use jsonwebtoken::{decode, Algorithm, DecodingKey, Validation};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
struct Claims {
    sub: String,
    scope: String,
}

fn check_token(token: &str, jwt: &str) -> bool {
    let decoded_token = decode::<Claims>(
        &token,
        &DecodingKey::from_secret(jwt.as_bytes()),
        &Validation::new(Algorithm::HS256),
    );
    match decoded_token {
        Ok(token_data) => token_data.claims.scope == "modify",
        Err(_) => false,
    }
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
