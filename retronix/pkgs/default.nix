{ nixpkgs ? (import ../npins).nixpkgs
,  pkgs ? import nixpkgs {}
}:
pkgs.extend (import ./overlay.nix)
