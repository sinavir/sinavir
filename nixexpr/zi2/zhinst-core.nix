{ lib
, buildPythonPackage
, fetchPypi
, fetchurl
, numpy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "zhinst-core";
  version = "23.6.46756";

  format = "wheel";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/6d/7c/48ddd61d253004a8580f7dbf14517cd6b428e35fd7fbe7b2a37c4735918a/zhinst_core-23.6.46756-cp311-cp311-manylinux1_x86_64.whl";
    hash = "sha256-8ZwGVlibrqvXbMRQyn/gDL3XxJiLi2AdslqX1kLVcm4=";
  };

  propagatedBuildInputs = [
    numpy
    typing-extensions
  ];

  pythonImportsCheck = [ "zhinst.core" ];

  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
