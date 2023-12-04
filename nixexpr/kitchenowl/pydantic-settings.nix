{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pydantic
, python-dotenv
}:

buildPythonPackage rec {
  pname = "pydantic-settings";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-settings";
    rev = "v${version}";
    hash = "sha256-hU7u/AzaqCHKSUDHybsgXTW8IWi9hzBttPYDmMqdZbI=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pydantic
    python-dotenv
  ];

  pythonImportsCheck = [ "pydantic_settings" ];

  meta = with lib; {
    description = "Settings management using pydantic";
    homepage = "https://github.com/pydantic/pydantic-settings";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
