{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, deprecated
, drawsvg
, exqalibur
, latexcodec
, matplotlib
, multipledispatch
, networkx
, numpy
, protobuf
, requests
, scipy
, sympy
, scmver
, tabulate
}:

buildPythonPackage rec {
  pname = "perceval-quandela";
  version = "0.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g8kbGBcLI6qxjRNhbF9pdfzGTLJf6PR0fSoyke+mSnI=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    deprecated
    drawsvg
    scmver
    exqalibur
    latexcodec
    matplotlib
    multipledispatch
    networkx
    numpy
    protobuf
    requests
    scipy
    sympy
    tabulate
  ];

  pythonImportsCheck = [ "perceval" ];

  meta = with lib; {
    description = "A powerful Quantum Photonic Framework";
    homepage = "https://pypi.org/project/perceval-quandela";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
