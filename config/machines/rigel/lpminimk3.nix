{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, jsonschema
, python-rtmidi
, websockets
}:

buildPythonPackage rec {
  pname = "lpminimk3";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "obeezzy";
    repo = "lpminimk3";
    rev = "v${version}";
    hash = "sha256-CVjBUKjLOFaIgCpwNIO/PJ55s7nQ0WMRKKqVS3xOI3g=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    jsonschema
    python-rtmidi
    websockets
  ];

  pythonImportsCheck = [ "lpminimk3" ];

  meta = with lib; {
    description = "Python API for the Launchpad Mini MK3";
    homepage = "https://github.com/obeezzy/lpminimk3";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
