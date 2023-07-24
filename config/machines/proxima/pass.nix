{
  pkgs,
  config,
  ...
}: {
  services.vaultwarden = {
    enable = true;
    config = rec {
      DOMAIN = "https://pass.sinavir.fr";
      WEBSOCKET_ENABLED = true;
      WEBSOCKET_PORT = 10500;
      SIGNUPS_ALLOWED = false;
      ROCKET_PORT = 10501;
      ROCKET_ADDRESS = "127.0.0.1";
      LOG_FILE = "/var/lib/bitwarden_rs/logs";
      SIGNUPS_VERIFY = true;
      SMTP_HOST = "mail.sinavir.fr";
      SMTP_FROM = "vaultwarden@sinavir.fr";
      SMTP_USERNAME = SMTP_FROM;
    };
    environmentFile = config.age.secrets."vaultwarden.env".path;
  };
  services.nginx.virtualHosts."pass.sinavir.fr" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:10501";
      proxyWebsockets = true;
    };
    locations."/notifications/hub" = {
      proxyPass = "http://localhost:10500";
      proxyWebsockets = true;
    };
    locations."/notifications/hub/negotiate" = {
      proxyPass = "http://localhost:10501";
      proxyWebsockets = true;
    };
  };
}
