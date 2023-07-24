{
  pkgs,
  config,
  lib,
  ...
}: {
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
