{
  pkgs,
  config,
  lib,
  ...
}: let
  host = "ntfy.sinavir.fr";
  listen = "localhost:4856";
in {
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${host}";
      listen-http = listen;
      auth-file = "/var/lib/ntfy/user.db";
      auth-default-access = "deny-all";
      behind-proxy = true;
      manager-interval = "1h";
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts.${host} = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://${listen}";
        proxyWebsockets = true;
      };
    };
  };
}
