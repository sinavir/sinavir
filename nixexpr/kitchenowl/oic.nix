{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pyoidc";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CZ-NIC";
    repo = "pyoidc";
    rev = version;
    hash = "sha256-HDvxiE+uEnQRK704HrDrHvDdKVUhXZWbdZzlPK382cg=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "oic" ];

  meta = with lib; {
    description = "A complete OpenID Connect implementation in Python";
    homepage = "https://github.com/CZ-NIC/pyoidc/";
    changelog = "https://github.com/CZ-NIC/pyoidc/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
