{ lib
, joblib
, matplotlib
, numpy
, pandas
, scikit-learn
, scipy
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, pytest
}:

buildPythonPackage rec {
  pname = "mlxtend";
  version = "0.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = "mlxtend";
    rev = "ad06b2d2fcb7fc3e3fe9450edd5d9a52475478d0";
    hash = "sha256-CnWexLcmcnRc2JeMWRnir9DQh8jD+QlXPm9oI+F+PRY=";
  };


  propagatedBuildInputs = [
    joblib
    matplotlib
    numpy
    pandas
    scikit-learn
    scipy
  ];
  nativeBuildInputs = [
    setuptools
    wheel
  ];

  passthru.optional-dependencies = {
    testing = [
      pytest
    ];
  };

  pythonImportsCheck = [ "mlxtend" ];

  meta = with lib; {
    description = "A library of extension and helper modules for Python's data analysis and machine learning libraries";
    homepage = "https://github.com/rasbt/mlxtend";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
