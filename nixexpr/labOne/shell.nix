{ pkgs ? import (import ./npins).nixpkgs { overlays = [ (import ./overlay.nix) ];} }:
pkgs.mkShell {
  packages = [
    pkgs.labOne
    pkgs.python311.withPackages (ps: [
      ps.zhinst-meta
      ps.numpy
      ps.matplotlib
      ps.pillow
      ps.gwyfile
    ])
  ];
}
