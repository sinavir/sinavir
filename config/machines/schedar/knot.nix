{ config, pkgs, ... }:
{
  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];
  services.knot = let
    # refresh 24h, retry 2h, expire, 1000h, TTL 48h
    zone = pkgs.writeTextDir "sinavir.fr.zone" (builtins.readFile ../../shared/sinavir.fr.zone);
    zonesDir = pkgs.buildEnv {
      name = "knot-zones";
      paths = [ zone ];
    };
  in {
    enable = true;
    extraArgs = [
      "-v"
    ];
    keyFiles = [ config.age.secrets.tsigNS2.path ];
    extraConfig = ''
      server:
          listen: 51.15.171.220@53
          listen: 2001:bc8:34d0::1@53

      log:
        - target: syslog
          any: debug

      remote:
        - id: ns2
          address: 2001:41d0:404:200::81a1@53
          key: tsigNS2

      acl:
        - id: transfer_to_ns2
          key: tsigNS2
          address: 2001:41d0:404:200::81a1
          action: transfer

      zone:
        - domain: sinavir.fr.
          file: sinavir.fr.zone
          storage: ${zonesDir}
          zonefile-sync: -1
          zonefile-load: difference
          acl: transfer_to_ns2
          notify: ns2
          semantic-checks: on
          dnssec-signing: on
    '';
  };
}
