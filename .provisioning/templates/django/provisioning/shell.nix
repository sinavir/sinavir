{ pkgs ? import (import ../npins).nixpkgs { } }:
pkgs.mkShell {
  buildInputs = [
    (pkgs.callPackage ./python.nix { debug = true; })
  ];
}
