{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.useDHCP = false;
  networking.firewall.allowedUDPPorts = [ 67 ];

  systemd.network = {
    enable = true;
    networks = {
      "10-uplink" = {
        name = "end0";
        networkConfig = {
          Address = "10.1.1.1/24";
          DHCPServer = "yes";
          IPMasquerade = "ipv4";
        };
        dhcpServerConfig = {
          PoolOffset=100;
          PoolSize=20;
          EmitDNS="yes";
          DNS="9.9.9.9";
        };
        dhcpServerStaticLeases = [
          {
            dhcpServerStaticLeaseConfig = {
              Address = "10.1.1.2";
              MACAddress = "14:b3:1f:06:3c:2e";
            };
          }
        ];
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
