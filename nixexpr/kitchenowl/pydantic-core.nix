{ lib
, buildPythonPackage
, fetchFromGitHub
, cargo
, rustPlatform
, rustc
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pydantic-core";
  version = "2.14.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-core";
    rev = "v${version}";
    hash = "sha256-UguZpA3KEutOgIavjx8Ie//0qJq+4FTZNQTwb/ZIgb8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-mMgw922QjHmk0yimXfolLNiYZntTsGydQywe7PTNnwc=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
    typing-extensions
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  pythonImportsCheck = [ "pydantic_core" ];

  meta = with lib; {
    description = "Core validation logic for pydantic written in rust";
    homepage = "https://github.com/pydantic/pydantic-core";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
