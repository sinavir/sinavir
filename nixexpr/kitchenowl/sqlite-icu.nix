{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, pkg-config
, icu
, sqlite
}:

buildPythonPackage rec {
  pname = "sqlite-icu";
  version = "1.0";
  #pyproject = true;

  src = fetchFromGitHub {
    owner = "karlb";
    repo = "sqlite-icu";
    rev = "b085bf5f9b7aa5a87a12a7ca16c2e7b7dbb22d27";
    hash = "sha256-cEsot8p0n58idn2aE0F4xrTObPCAevBCWrwOaAOGWbQ=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    pkg-config
  ];
  buildInputs = [
    icu
    sqlite
  ];

  pythonImportsCheck = [ "sqlite_icu" ];

  meta = with lib; {
    description = "Loadable ICU extension for sqlite as python package";
    homepage = "https://github.com/karlb/sqlite-icu";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
