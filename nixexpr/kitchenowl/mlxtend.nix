{ lib
, python311
, fetchFromGitHub
,    joblib
,    matplotlib
,    numpy
,    pandas
,    scikit-learn
,    scipy
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "mlxtend";
  version = "0.22.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = "mlxtend";
    rev = "v${version}";
    hash = "sha256-YLCNLpg2qrdFon0/gdggJd9XovHwRHAdleBFQc18qzE=";
  };


  propagatedBuildInputs = [
    joblib
    matplotlib
    numpy
    pandas
    scikit-learn
    scipy
  ];

  pythonImportsCheck = [ "mlxtend" ];
  doCheck = false;



  meta = with lib; {
    description = "A library of extension and helper modules for Python's data analysis and machine learning libraries";
    homepage = "https://github.com/rasbt/mlxtend";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
