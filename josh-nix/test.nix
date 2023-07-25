{ nixpkgs ? (import ./npins).nixpkgs
, pkgs ? import nixpkgs {},
}:
let
  nixos-lib = import (nixpkgs + "/nixos/lib") { };
in nixos-lib.runTest {
  name = "Test josh";
  hostPkgs = pkgs;
  nodes = {
    machine = {
    };
  testScript =  "";
}
