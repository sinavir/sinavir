{
  lib,
  pkgs,
  buildPythonApplication,
  aiosqlite,
  websockets,
  fetchFromGitHub,
}:
buildPythonApplication rec {
  pname = "ws-scraper";
  version = "0.1";
  doCheck = false;
  src = fetchFromGitHub {
    owner = "sinavir";
    repo = "ws-scraper";
    rev = "5cceaae90b5066db80de6374fb51a12382d36b86";
    sha256 = "sha256-xadxI6HK+aKYfCm2ljeIybW28eo8vEgzburCVm7JSIU=";
  };
  propagatedBuildInputs = [aiosqlite websockets];
}
