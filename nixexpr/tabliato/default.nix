{
  nixpkgs ? (import ../npins).nixpkgs,
  pkgs ? import nixpkgs {},
}:
pkgs.libsForQt5.callPackage ./tabliato.nix {}
