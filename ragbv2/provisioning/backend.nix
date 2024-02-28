{ lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "ragb-backend";
  version = "0.1";

  src = ../backend;

  cargoHash = "sha256-Z4OxgswSd7Ton3vbricAQ5cYpvLzHTtjRcISXBr1bD0=";
}
