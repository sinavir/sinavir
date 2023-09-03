{ lib
, stdenv
, fetchFromGitHub
, php
}:
php.buildComposerProject (finalAttrs: {
  pname = "lychee";
  version = "4.11.1";

  src = fetchFromGitHub {
    owner = "LycheeOrg";
    repo = "Lychee";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xsGNkdKPs7/edzo5OpSR+S9uKmPLRzyPPwGIdRpKdV4=";
  };

  php = (php.buildEnv {
    extensions = ({ enabled, all, }:
    enabled ++ [all.imagick all.bcmath all.mbstring all.gd]);
  });

  composerNoDev = true;
  
  vendorHash = "sha256-rPE2S8lYm3H95M/EGFnvcE675agegTzgon9GaJfXx1E=";

  meta = with lib; {
    description = "A great looking and easy-to-use photo-management-system you can run on your server, to manage and share photos";
    homepage = "https://github.com/LycheeOrg/Lychee";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
})
