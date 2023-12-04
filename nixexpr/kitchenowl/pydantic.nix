{ lib
, buildPythonPackage
, fetchFromGitHub
, hatch-fancy-pypi-readme
, hatchling
, annotated-types
, importlib-metadata
, pydantic-core
, typing-extensions
, email-validator
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    rev = "v${version}";
    hash = "sha256-D0gYcyrKVVDhBgV9sCVTkGq/kFmIoT9l0i5bRM1qxzM=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [
    annotated-types
    importlib-metadata
    pydantic-core
    typing-extensions
  ];

  passthru.optional-dependencies = {
    email = [
      email-validator
    ];
  };

  pythonImportsCheck = [ "pydantic" ];

  meta = with lib; {
    description = "Data validation using Python type hints";
    homepage = "https://github.com/pydantic/pydantic";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
