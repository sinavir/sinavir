{
  pkgs,
  config,
  lib,
  ...
}: let
  domain = "auth.sinavir.fr";
  port = 11009;
in {
  services.keycloak = {
    enable = true;
    settings = {
      http-host = "localhost";
      http-port = port;
      proxy = "edge";
      hostname-strict-backchannel = true;
      hostname = domain;
    };
    database.passwordFile = "${config.age.secrets.keycloakDatabasePasswordFile.path}";
  };
  services.nginx = {
    enable = true;
    virtualHosts."auth.sinavir.fr" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${builtins.toString port}";
        extraConfig = ''
          # For large authentication-authorization headers
          proxy_buffer_size          128k;
          proxy_buffers              4 256k;
          proxy_busy_buffers_size    256k;
        '';
      };
    };
  };
}
