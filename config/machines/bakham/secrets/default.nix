{
  pkgs,
  config,
  lib,
  ...
}: {
  age.secrets."wg" = {
    file = ./wg.age;
    owner = "systemd-network";
  };
}
