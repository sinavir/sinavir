{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage {
  pname = "arkheon";
  version = "unstable-2024-02-27";

  VITE_BACKEND_URL="@backend@";

  src = fetchFromGitHub {
    owner = "RaitoBezarius";
    repo = "mimir";
    rev = "be5b4df58da00f04028d1aa7e43b3d8a1467fe13";
    hash = "sha256-tTieJINAfTdNJvkgYdsW2G11sqrRc4UDJ3e0m9qZgC8=";
  };

  npmDepsHash = "sha256-pTzP0bx++/jglyYBDBirzUsK/2rTTMbagMUwU0eIdm0=";

  sourceRoot = "source/frontend";

  installPhase = ''
    mkdir -p $out
    mv dist/* $out
  '';

  meta = with lib; {
    description = "Track your Nix closures over time";
    homepage = "https://github.com/RaitoBezarius/mimir/";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ];
    mainProgram = "arkheon";
    platforms = platforms.all;
  };
}
