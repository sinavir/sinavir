{ lib
, rustPlatform
, buildGoModule
, breakpointHook
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
, nodejs
, npmHooks
, fetchNpmDeps
, tree
, python3
, curl
, git
}:
let
version = "23.02.14";

src = fetchFromGitHub {
  owner = "josh-project";
  repo = "josh";
  rev = "4b40183c3f7d17d4d8d13279d874f69c902dfc7e"; #"r${finalAttrs.version}";
  hash = "sha256-a1f0kZjseRoc75t1oC+RmMDp5AoCzkp7pzb1injiAGw=";
};

joshSshDevServer = buildGoModule rec {
  pname = "josh-ssh-dev-server";
  inherit version src;
  sourceRoot = "source/josh-ssh-dev-server";
};
package = rustPlatform.buildRustPackage (rec {
  pname = "josh";

  inherit version src;

  JOSH_VERSION = version;

  outputs = [ "out" "web" ];

  cargoHash = "sha256-wCETfTfKs7q6ltuykanUhKlZRU//W515+2ANqhAz5X8=";

  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps";
    inherit src;
    sourceRoot = "source/josh-ui";
    hash = "sha256-AN4GfcPD2XwgYa/CnY/28DbPSKoCyBub4wH6/lrljmo=";
  };
  
  npmRoot="josh-ui";

  nativeBuildInputs = [
    pkg-config
    nodejs
    npmHooks.npmConfigHook
    breakpointHook
  ];

  preBuild = "echo $TRIPLE";
  buildInputs = [
    libgit2
    python3
    openssl
    zlib
  ];

  PUBLIC_URL = "/josh-ui/";
  TRIPLE = stdenv.hostPlatform.config;
  
  postInstall = ''
    mkdir -p $web
    mkdir -p $out/bin
    mv scripts/git-sync $out/bin
    mv static/* $web
    '';
  checkFetures = [ "test-server" ];
  nativeCheckInputs = [ joshSshDevServer tree python3.pkgs.cram curl git ];
  postCheck = ''
    # patch tests to work with our config. Using a poor man's hack
    ln -s $TRIPLE/release ./target/debug

    bash run-tests.sh -v ./tests/
    '';

  passthru = {
    shellPath = "/bin/josh-ssh-shell";
  };

  meta = with lib; {
    description = "Just One Single History";
    homepage = "https://github.com/josh-project/josh";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
});
in package
