{ lib
, buildPythonPackage
, fetchurl
, setuptools
, setuptools-scm
, wheel
, numpy
, zhinst-core
}:

buildPythonPackage rec {
  pname = "zhinst-utils";
  version = "0.3.4";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/00/79/e1fe516198d49c26eab74ed7dcf7f106bc470261b931be798a6ecd82ad13/zhinst_utils-0.3.4-py3-none-any.whl";
    hash = "sha256-33fisC/dDhz7eapa+P2qmvqzVtVCG9gEOzU71xItQ+4=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    zhinst-core
  ];

  #pythonImportsCheck = [ "zhinst.utils.shfqa" ];

  meta = with lib; {
    description = "Intermediate Layer above the zhinst.core module that provides additional functions the ease the use of our instruments";
    homepage = "https://github.com/zhinst/zhinst-utils";
    changelog = "https://github.com/zhinst/zhinst-utils/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
