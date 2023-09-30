{ lib
, fetchFromGitHub
, gitMinimal
, buildPythonPackage
, numpy
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dbscan1d";
  version = "0.2.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "d-chambers";
    repo = "dbscan1d";
    rev = "v${version}";
    hash = "sha256-Q+JCGTcn9FMPOb5kN1vsl/SbZaPjTf3Y2kIMVk5AIJ0=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    gitMinimal
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "dbscan1d" ];

  meta = with lib; {
    description = "An efficient 1D implementation of the DBSCAN clustering algorithm";
    homepage = "https://github.com/d-chambers/dbscan1d";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
