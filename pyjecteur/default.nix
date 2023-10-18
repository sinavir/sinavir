{ pkgs ? import (import ./npins).nixpkgs {} }:
pkgs.python310Packages.callPackage ./pyjecteur.nix {}
