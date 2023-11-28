{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, wheel
, zhinst-core
, zhinst-toolkit
, zhinst-utils
}:

buildPythonPackage rec {
  pname = "zhinst";
  version = "23.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M+mmnszlLmi2JqBgFdY8o8f2Q0H9yaYw+I2yyhGJ4pU=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    zhinst-core
    zhinst-toolkit
    zhinst-utils
  ];

  pythonImportsCheck = [ "zhinst" ];

  meta = with lib; {
    description = "Zurich Instruments Python API";
    homepage = "https://pypi.org/project/zhinst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
