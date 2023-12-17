{ breakpointHook, php, fetchFromGitLab, lib }:
php.buildComposerProject (finalAttrs: {
  pname = "castopod";
  version = "1.7.2";
  src = fetchFromGitLab {
    domain = "code.castopod.org";
    owner = "adaures";
    repo = "castopod";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7Tm/CtXWbLYbDWxSdk9vWMVxQ7fFF+nBSkRb2xJDsKw=";
  };
  composerStrictValidation = false;
  php = php.withExtensions ({ enabled, all }: with all; [
    intl
    curl
    mbstring
    gd
    exif
    mysqlnd
  ] ++ enabled);
  vendorHash = lib.fakeHash;
})
