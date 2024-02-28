{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pydantic
, fastapi
, uvicorn
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "arkheon";
  version = "unstable-2024-02-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RaitoBezarius";
    repo = "mimir";
    rev = "be5b4df58da00f04028d1aa7e43b3d8a1467fe13";
    hash = "sha256-tTieJINAfTdNJvkgYdsW2G11sqrRc4UDJ3e0m9qZgC8=";
  };

  patches = [ ./arkheon.patch ];

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs =  [
    fastapi
    pydantic
    sqlalchemy
    uvicorn
  ];

  meta = with lib; {
    description = "Track your Nix closures over time";
    homepage = "https://github.com/RaitoBezarius/mimir/";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ];
    mainProgram = "arkheon";
    platforms = platforms.all;
  };
}
