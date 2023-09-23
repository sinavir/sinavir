# TODO: Build dist dir
{ lib, stdenv, fetchFromGitLab, zip }:
stdenv.mkDerivation {
  name = "mkbootimg";
  src = lib.cleanSourceWith {
    src = fetchFromGitLab {
      owner = "bztsrc";
      repo = "bootboot";
      rev = "master";
      hash = "sha256-+oOwLkqVJSnfsaLx40zStLT1+0WCgpjC1k76C2rSUG4=";
    };
    filter = path: type: type != "directory" || builtins.elem (builtins.baseNameOf path) [ "mkbootimg" "dist" ];
  };
  buildInputs = [ zip ];
  buildPhase = ''
    make -C mkbootimg
    '';
  installPhase = ''
    mkdir -p $out/bin
    mv mkbootimg/mkbootimg $out/bin/mkbootimg
    '';

}
