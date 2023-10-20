{
  pkgs,
  config,
  lib,
  ...
}: {
  age.secrets = {
    "cdFanfPasswd" = {
      file = ./cdfanf-passwd.age;
      owner = "nginx";
      group = "nginx";
    };
    "ragb".file = ./ragb.age;
    "ragb_devkey".file = ./ragb_devkey.age;
  };
}
