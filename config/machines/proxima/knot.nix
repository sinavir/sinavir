{ config, pkgs, ... }:
{
  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];
  services.knot = let
    zonesDir = pkgs.buildEnv {
      name = "knot-zones";
      paths = [];
    };
  in {
    enable = true;
    extraArgs = [
      "-v"
    ];
    settingsFile = pkgs.writeText "knot.conf" ''
      include: ${config.age.secrets.tsigNS2.path}
      server:
          listen: 51.210.243.54@53
          listen: 2001:41d0:404:200::81a1@53

      log:
        - target: syslog
          any: debug

      remote:
        - id: ns1
          address: 2001:bc8:34d0::1@53
          key: tsigNS2

      acl:
        - id: notify_from_ns1
          key: tsigNS2
          address: 2001:bc8:34d0::1
          action: notify

      zone:
        - domain: sinavir.fr.
          file: sinavir.fr.zone
          acl: notify_from_ns1
          master: ns1
          zonefile-sync: -1
          semantic-checks: on
    '';
  };
}
