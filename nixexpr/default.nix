{ nixpkgs ? (import ./npins).nixpkgs, pkgs ? import nixpkgs {} }:
{
  pyzo = pkgs.python3Packages.callPackage ./pyzo.nix {};
  x32edit = pkgs.callPackage ./x32edit.nix {
    curlWithGnuTls = pkgs.curl.override { gnutlsSupport = true; opensslSupport = false; };
  };
  qlcplus = pkgs.libsForQt5.callPackage ./qlcplus.nix { };
  bootboot = pkgs.callPackage ./bootboot { };
}
