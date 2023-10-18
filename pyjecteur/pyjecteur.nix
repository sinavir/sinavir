{ lib , pkgs, stdenv, setuptoolsBuildHook, buildPythonPackage, pythonPackages , fetchFromGitHub }:
buildPythonPackage rec {
  pname = "pyjecteur";
  version = "2.0";
  doCheck = false;
  src = ./. ;
  propagatedBuildInputs = [ pythonPackages.pyserial pythonPackages.colour ];
}
