{
  pkgs,
  config,
  lib,
  ...
}: {
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
  };
  boot.loader.efi.efiSysMountPoint = "/boot";
}
