{
  nixpkgs ? (import ./npins).nixpkgs,
  pkgs ? import ((import nixpkgs {}).applyPatches { src = nixpkgs; patches = [ ./composer-builder.patch ]; }) {},
}:
pkgs.callPackage ./lychee.nix {}
