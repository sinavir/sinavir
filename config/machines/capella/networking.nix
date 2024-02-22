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
        dhcpV4Config = {
          RouteMetric = 1000;
        };
      };
      "10-wifi" = {
        name = "wlan0";
        DHCP = "yes";
        networkConfig = {
        };
        dhcpV4Config = {
          RouteMetric = 2000;
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
  networking.wireless = {
    #userControlled.enable = true;
    enable = true;
    networks."CableBox-CBB8".psk = "@PSK_CABLEBOX@";
    environmentFile = config.age.secrets.wifi.path;
    extraConfig = ''
      country=FR
    '';
  };

  #networking.firewall.allowedUDPPorts = [ 1194 ];
}
