{ lib
, fetchzip
}:
fetchzip {
  url = "https://github.com/LycheeOrg/Lychee/releases/download/v4.11.1/Lychee.zip";
  hash = "sha256-VuzTf2ZGkmBtOs2UjDmULKyp3SS/tPdkgZrHc92ixmY=";

  meta = with lib; {
    description = "A great looking and easy-to-use photo-management-system you can run on your server, to manage and share photos";
    homepage = "https://github.com/LycheeOrg/Lychee";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };

#  php = (php.buildEnv {
#    extensions = ({ enabled, all, }:
#    enabled ++ [all.imagick all.bcmath all.mbstring all.gd]);
#  });


}
