let
  pkgs = import (import ./npins).nixos-unstable {};
in
  pkgs.mkShell {
    packages = with pkgs; [
      npins
      colmena
    ];

    allowSubstitutes = false;
  }
