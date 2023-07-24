{
  pkgs,
  lib,
  config,
  ...
}: {
  services.thelounge = {
    enable = true;
    port = 9000;
    extraConfig = {
      reverseProxy = true;
      host = "127.0.0.1";
      public = false;
      prefetch = true;
      fileUpload = {
        enable = true;
      };
    };
  };
  services.nginx.enable = true;
  services.nginx.virtualHosts."irc.sinavir.fr" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:9000";
      proxyWebsockets = true;
    };
  };
  networking.firewall.allowedTCPPorts = [80 443];
}
