{ pkgs ? import (import ./npins).nixpkgs { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    typst
    typst-lsp
    typst-fmt
  ];
}
