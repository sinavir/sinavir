{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "sseclient";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mpetazzoni";
    repo = "sseclient";
    rev = "sseclient-py-${version}";
    hash = "sha256-rNiJqR7/e+Rhi6kVBY8gZJZczqSUsyszotXkb4OKfWk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "sseclient" ];

  meta = with lib; {
    description = "Pure-Python Server Side Events (SSE) client";
    homepage = "https://github.com/mpetazzoni/sseclient";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
