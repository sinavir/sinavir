{ lib, stdenv, fetchurl, python, buildPythonPackage, autoPatchelfHook }:
buildPythonPackage {
  pname = "exqalibur";
  version = "0.2.1";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/1b/70/d9070cad2e7db47e53186b0521d12011f4acfd836eb54178feb5a485de42/exqalibur-0.2.1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
    hash = "sha256-GOCkIVZETmU35htAGMnqXYakFmTP95q5+s1vkIpOlsA=";
  };
  disabled = python.pythonVersion == "311";
  format = "wheel";
  nativeBuildInputs = [autoPatchelfHook];
}
