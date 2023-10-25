{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, wheel
, jsonref
, jsonschema
, numpy
, pyelftools
, typing-extensions
, zhinst-core
, zhinst-utils
}:

buildPythonPackage rec {
  pname = "zhinst-toolkit";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r33DnUKozjmviviciQhAIgZPMoASPsQ/G7SgQI08COQ=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    jsonref
    jsonschema
    numpy
    pyelftools
    typing-extensions
    zhinst-core
    zhinst-utils
  ];

  pythonImportsCheck = [ "zhinst" ];

  meta = with lib; {
    description = "Zurich Instruments Toolkit High Level API";
    homepage = "https://pypi.org/project/zhinst-toolkit/#description";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
