{ pkgs ? import (import ../npins).nixpkgs { } }:
pkgs.mkShell {
  buildInputs = [
    (pkgs.callPackage ./python.nix { debug = true; })
    pkgs.redis
    pkgs.cargo
    pkgs.rustc
    pkgs.rust-analyzer
    pkgs.rustfmt
  ];
}
