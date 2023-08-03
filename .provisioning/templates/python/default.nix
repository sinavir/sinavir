{ nixpkgs ? (import ./npins).nixpkgs, pkgs ? import nixpkgs {}}:
pkgs.python3.pkgs.buildPythonPackage rec {
  pname = builtins.throw "Insert name";
  version = "0.1.0";
  format = "pyproject";
  src = ./.;
  propagatedBuildInputs = [
    pkgs.python3.pkgs.setuptools
  ];
}
