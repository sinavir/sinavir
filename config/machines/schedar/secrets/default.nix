{
  pkgs,
  config,
  lib,
  ...
}: {
  age.secrets = {
    "vpn_preauth".file = ./vpn_preauth.age;
    "tsigNS2" = {
      file = ../../../shared/secrets/knot-tsigNS2.age;
      group = "knot";
      owner = "knot";
    };
    "netbox" = {
      file = ./netbox.age;
      group = "netbox";
      owner = "netbox";
    };
    "bk-passwd".file = ./bk-passwd.age;
    "bk-key".file = ./bk-key.age;
    "kitchenowl".file = ./kitchenowl.age;
  };
}
