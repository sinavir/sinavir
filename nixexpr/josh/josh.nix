{ lib
, breakpointHook
, stdenv
, fetchFromGitHub
, fetchNpmDeps
, npmHooks
, fetchpatch
, rustPlatform
, libgit2
, nodejs
, openssl
, pkg-config
, makeWrapper
, git
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "josh";
  version = "23.02.14";
  JOSH_VERSION = "r${version}";

  src =
    fetchFromGitHub {
      owner = "josh-project";
      repo = "josh";
      rev = "d27335a668dcc64221336e49848824eae6795bc4";
      hash = "sha256-nSlzp+I5kguLLyNsci9rNIVwmhZ3p0BgDqkJwHocW2M=";
    };


  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps";
    inherit src;
    sourceRoot = "source/josh-ui";
    hash = "sha256-AN4GfcPD2XwgYa/CnY/28DbPSKoCyBub4wH6/lrljmo=";
  };

  npmRoot="josh-ui";

  cargoHash = "sha256-wCETfTfKs7q6ltuykanUhKlZRU//W515+2ANqhAz5X8=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    nodejs
    npmHooks.npmConfigHook
    breakpointHook
  ];

  outputs = [ "out" "web" ];

  buildInputs = [
    libgit2
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.Security
  ];

  postInstall = ''
    mv scripts/git-sync $out/bin
    #wrapProgram "$out/bin/josh-proxy" --prefix PATH : "${git}/bin"
    #wrapProgram "$out/bin/git-sync" --prefix PATH : "${git}/bin"

    mkdir -p $web
    mv static/* $web
  '';

  passthru = {
    shellPath = "/bin/josh-ssh-shell";
  };

  meta = {
    description = "Just One Single History";
    homepage = "https://josh-project.github.io/josh/";
    downloadPage = "https://github.com/josh-project/josh";
    changelog = "https://github.com/josh-project/josh/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sternenseemann
      lib.maintainers.tazjin
    ];
    platforms = lib.platforms.all;
  };
}
