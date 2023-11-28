{ lib , pkgs, stdenv, setuptoolsBuildHook, buildPythonPackage, pythonPackages , fetchFromGitHub }:
let
  attrs = {
    name = "pyjecteur";
    version = "2.0";
    doCheck = false;
    src = ./. ;
    passthru = {
      wheel = buildPythonPackage (attrs // {
        name = "pyjecteur-py3.whl";
        installPhase = "mv dist/pyjecteur-2.0-py3-none-any.whl $out";
        dontFixup = true;
        doInstallCheck = false;
      });
    };
    propagatedBuildInputs = [ pythonPackages.pyserial pythonPackages.colour ];
  };
in
buildPythonPackage attrs
