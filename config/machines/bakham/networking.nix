{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.useDHCP = true;

  networking.wireless.userControlled.enable = true;
  networking.wireless.enable = true;

  systemd.network = {
    enable = true;

    networks = {
      "99-ethernet-default-dhcp" = {
        matchConfig.Name = ["en*" "eth*"];
        DHCP = "yes";
      };
      "10-uplink" = {
        name = "enu1u1";
        DHCP = "yes";
      };
      "50-wg0" = {
        name = "wg0";
        address = [
          "10.10.10.5/24"
        ];
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
    netdevs = {
      "50-wg0" = {
        netdevConfig = {
          Name = "wg0";
          Kind = "wireguard";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets."wg".path;
        };

        wireguardPeers = [
          {
            wireguardPeerConfig = {
              AllowedIPs = [
                "10.10.10.1/24"
              ];
              PublicKey = "CzUK0RPHsoG9N1NisOG0u7xwyGhTZnjhl7Cus3X76Es=";
              Endpoint="129.199.129.76:1194";
          PersistentKeepalive = 5;
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

}
