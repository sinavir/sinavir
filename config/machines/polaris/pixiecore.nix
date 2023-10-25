{ pkgs, config, lib, nodes, ... }:
let
  bootSystem = nodes.nekkar.config;
  netboot = pkgs.symlinkJoin {
    name = "netboot";
    paths = with bootSystem.system.build; [
      netbootRamdisk
      kernel
      netbootIpxeScript
    ];
  };
in {
  services.pixiecore = {
    enable = true;
    kernel = "${netboot}/bzImage";
    initrd = "${netboot}/initrd";
    cmdLine = "init=${bootSystem.system.build.toplevel}/init loglevel=4";
    debug = true;
    dhcpNoBind = true;
    port = 6666;
    statusPort = 6666;
  };
}
