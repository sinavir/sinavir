{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/tailscale.nix
  ];
  networking.useDHCP = false;
  networking.nameservers = ["9.9.9.9" "1.1.1.1"];

  systemd.network = {
    enable = true;
    networks = {
      "10-uplink" = {
        name = "enp1s0";
        address = [
          "51.15.171.220/24"
        ];

        networkConfig = {
          Gateway = "51.15.171.1";
          DHCP = "ipv6";
          IPv6AcceptRA = true;
        };

        ipv6AcceptRAConfig = {
          UseDNS = false;
          UseOnLinkPrefix = false;
          UseAutonomousPrefix = false;
        };

        dhcpV6Config = {
          UseDNS = false;
          UseNTP = false;
          UseDelegatedPrefix = true;
          UseAddress = false;
          WithoutRA = "solicit";
          PrefixDelegationHint = "2001:bc8:34d0::0/48";
        };

        dhcpV4Config = {
          ClientIdentifier = "duid-only";
          DUIDType = "link-layer";
          DUIDRawData = "00:01:66:24:f3:dd:56:fe";
        };
      };
    };
  };
  # Dummy interface for ipv6

  systemd.network.netdevs."10-dummy0".netdevConfig = {
    Name = "dummy0";
    Kind = "dummy";
  };

  systemd.network.networks."10-dummy0" = {
    name="dummy0";
    address = [ "2001:bc8:34d0::1" ];
  };
}
