{ config, ... }:

let
  host = "status.sinavir.fr";

  port = 3001;

in {
  services.uptime-kuma.enable = true;

  services.nginx = {
    enable = true;

    virtualHosts.${host} = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString port}";
        proxyWebsockets = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
