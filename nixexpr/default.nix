{ nixpkgs ? <nixpkgs>, pkgs ? import nixpkgs {} }:
{
  pyzo = pkgs.python3Packages.callPackage ./pyzo.nix {};
  x32edit = pkgs.callPackage ./x32edit.nix {
    curlWithGnuTls = pkgs.curl.override { gnutlsSupport = true; opensslSupport = false; };
  };
  eggnoggplus = pkgs.callPackage ./eggnoggplus.nix {};
  qlcplus = pkgs.libsForQt5.callPackage ./qlcplus.nix { };
  bootboot = pkgs.callPackage ./bootboot { };
}
