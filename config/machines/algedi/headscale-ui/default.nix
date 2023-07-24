{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "headscale-ui";
  version = "2023.01.30-beta-1";

  src = fetchFromGitHub {
    owner = "gurucomputing";
    repo = pname;
    rev = "${version}";
    hash = "sha256-PtEiisTVlcAgEWDE3nSCdyd8L1hliORfkR3DbJOSqq0=";
  };

  npmDepsHash = "sha256-fQIe7SKsv4HvST76xTUy1uxaPmwVLiGnfvEvpH5WALQ=";
  makeCacheWritable = true;

  patches = [./patch.patch];

  installPhase = ''
    mkdir -p $out
    cp -r ./build $out/web
  '';

  meta = with lib; {
    description = "A web frontend for the headscale Tailscale-compatible coordination server.";
    homepage = "https://github.com/gurucomputing/headscale-ui";
    license = licenses.bsd3;
  };
}
