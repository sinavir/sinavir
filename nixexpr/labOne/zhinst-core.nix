{ lib, stdenv, fetchurl, python, buildPythonPackage, autoPatchelfHook }:
buildPythonPackage {
  pname = "zhinst-core";
  version = "23.10.49450";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/76/c6/cfc2517ad861396cfc8dc786996afd7a90d6c899eb16e696f3d31872cf6e/zhinst_core-23.10.49450-cp311-cp311-manylinux1_x86_64.whl";
    hash = "sha256-zuXkUBZw4qaST009enPgwlKgHqTqIqRfV6udm8Or5FI=";
  };
  disabled = python.pythonVersion == "311";
  format = "wheel";
  nativeBuildInputs = [autoPatchelfHook];
}
