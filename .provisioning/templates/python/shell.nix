{ nixpkgs ? (import ./npins).nixpkgs, pkgs ? import nixpkgs {}}:
let
  defaultPackage = import ./. { inherit nixpkgs pkgs; };
in
pkgs.mkShell {
  inputsFrom = [ defaultPackage ];
}
