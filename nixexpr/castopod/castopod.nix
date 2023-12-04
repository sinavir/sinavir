{ breakpointHook, php, fetchFromGitLab, lib }:
php.buildComposerProject (finalAttrs: {
  pname = "castopod";
  version = "1.6.5";
  src = fetchFromGitLab {
    domain = "code.castopod.org";
    owner = "adaures";
    repo = "castopod";
    rev = "aeaee8ae64df485f7f0863e1947f06dafd5204cb";
    hash = "sha256-RnJKczLL38By8HHTJ6fR1w0YuVTe2FL0F8pdX+jhigM=";
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
