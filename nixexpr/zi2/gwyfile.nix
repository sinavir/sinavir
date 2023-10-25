{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, numpy
, six
}:

buildPythonPackage rec {
  pname = "gwyfile";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z3L+3WrxXJUgZ9u+h5eKSmJitOLNOqny577kztQHHkA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];
  propagatedBuildInputs = [
    numpy
    six
  ];

  pythonImportsCheck = [ "gwyfile" ];

  meta = with lib; {
    description = "Pure Python implementation of the Gwyddion file format";
    homepage = "https://pypi.org/project/gwyfile/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
