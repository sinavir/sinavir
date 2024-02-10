{ nixpkgs ? (import ./npins).nixpkgs
,  pkgs ? import nixpkgs {}
}:
let
  patchedPkgs = pkgs.extend (import ./overlay.nix);
in
  patchedPkgs
