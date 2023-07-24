{
  pkgs,
  config,
  lib,
  ...
}: {
  age.secrets = {
    "vpn_preauth" = {
      file = ./vpn_preauth.age;
    };
  };
}
