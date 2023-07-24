{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [../../modules/tailscale.nix];

  networking.useDHCP = false;

  systemd.network = {
    enable = true;
    networks = {
      "10-uplink" = {
        name = "end0";
        DHCP = "yes";
        networkConfig = {
        };
      };
    };
  };
  networking.nameservers = [
    "2620:fe::fe"
    "2620:fe::9"
    "9.9.9.9"
    "149.112.112.112"
  ];
  #networking.firewall.allowedUDPPorts = [ 1194 ];
}
