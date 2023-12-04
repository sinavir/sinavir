{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, wheel
, nltk
, python-crfsuite
, typing-extensions
}:

buildPythonPackage rec {
  pname = "ingredient-parser";
  version = "0.1.0-beta7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "strangetom";
    repo = "ingredient-parser";
    rev = version;
    hash = "sha256-YKjwO3uq99eaw9PtDietpyQL9DtAswZJPrW63l1RLho=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    nltk
    python-crfsuite
    typing-extensions
  ];

  pythonImportsCheck = [ "ingredient_parser" ];

  meta = with lib; {
    description = "A tool to parse recipe ingredients into structured data";
    homepage = "https://github.com/strangetom/ingredient-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
