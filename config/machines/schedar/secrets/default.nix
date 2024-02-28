{
  pkgs,
  config,
  lib,
  ...
}: {
  age.secrets = {
    "vpn_preauth".file = ./vpn_preauth.age;
    "ragb".file = ./ragb.age;
    "ragbJWT".file = ./ragbJWT.age;
    "tsigNS2" = {
      file = ../../../shared/secrets/knot-tsigNS2.age;
      group = "knot";
      owner = "knot";
    };
    "bk-passwd".file = ./bk-passwd.age;
    "bk-key".file = ./bk-key.age;
    "kitchenowl".file = ./kitchenowl.age;
  };
}
