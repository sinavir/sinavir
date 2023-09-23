{ nixpkgs ? (import ./npins).nixpkgs, pkgs ? import nixpkgs {} }:
{
  pyzo = pkgs.python3Packages.callPackage ./pyzo.nix {};
  x32edit = pkgs.callPackage ./x32edit.nix {
    curlWithGnuTls = pkgs.curl.override { gnutlsSupport = true; opensslSupport = false; };
  };
  bootboot = pkgs.callPackage ./bootboot { };
}
