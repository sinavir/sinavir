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
    user: User,
}

#[derive(Eq, PartialEq, Hash, Debug, Serialize, Deserialize, Clone)]
pub struct User(String);

fn check_token(token: &str, jwt: &str) -> Option<User> {
    let decoded_token = decode::<Claims>(
        &token,
        &DecodingKey::from_secret(jwt.as_bytes()),
        &Validation::new(Algorithm::HS256),
    );
    match decoded_token {
        Ok(token_data) => {
            let user =token_data.claims.user;
            if token_data.claims.scope == "modify" {
                tracing::info!("Successful auth {user:?}");
                Some(user)
            } else {
                tracing::debug!("Failed auth: {user:?} don't have modify scope");
                None
            }
        }
        Err(err) => {tracing::debug!("Failed decoding token: {err:?}"); None},
    }
}

pub async fn jwt_middleware(
    State(state): State<DB>,
    TypedHeader(auth): TypedHeader<headers::Authorization<headers::authorization::Bearer>>,
    mut request: Request,
    next: Next,
) -> Result<Response, StatusCode> {
    let token = auth.token();
    if let Some(user) = check_token(token, &state.static_state.jwt_key) {
        request.extensions_mut().insert(user);
        Ok(next.run(request).await)
    } else {
        Err(StatusCode::FORBIDDEN)
    }
}
