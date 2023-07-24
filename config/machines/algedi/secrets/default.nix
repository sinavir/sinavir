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
  };
}
