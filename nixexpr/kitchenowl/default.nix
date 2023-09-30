{
  nixpkgs ? (import ../npins).nixpkgs,
  pkgs ? import nixpkgs {},
}:
pkgs.callPackage ./kitchenowl.nix {}
