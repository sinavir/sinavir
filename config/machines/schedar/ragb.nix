{ lib, pkgs, config, ... }:
{
  imports = [ ../../../djangonix/module.nix ];
  services.django.ragb = {
    enable = true;
    src = ../../../ragbv2/frontend;
    settings = {
      SECRET_KEY_FILE = "$CREDENTIALS_DIRECTORY/secret_key";
      JWT_SECRET_FILE = "$CREDENTIALS_DIRECTORY/jwt_secret";
      #DEV_KEY_FILE = "$CREDENTIALS_DIRECTORY/dev_key";
      DEBUG = false;
      WEBSOCKET_ENDPOINT = "https://agb.hackens.org/api";
      ALLOWED_HOSTS = [ "127.0.0.1" "agb.sinavir.fr" "agb.hackens.org" ];
      DB_ENGINE = "django.db.backends.sqlite3";
      DB_NAME = "$STATE_DIRECTORY/ragb_frontend.sqlite3";
      ENABLE_DJDT = "0";
    };
    envPrefix = "";
    sourceRoot = ".";
    processes = 8;
    threads = 16;
    port = 9991;
    pythonPackage = pkgs.callPackage ../../../ragbv2/provisioning/python.nix {};
  };
  services.nginx.virtualHosts."agb.sinavir.fr" = {
    forceSSL = true;
    enableACME = true;
    serverAliases = [ "agb.hackens.org" ];
    locations = {
      "/" = {
        proxyPass = "http://localhost:9991";
      };
      "/api" = {
        proxyPass = "http://localhost:9999";
        proxyWebsockets = true;
      };
      "/static".root = config.services.django.ragb.staticAssets;
      "/api-docs" = {
        root = ../../../ragbv2/api-docs;
        extraConfig = "autoindex on;";
      };
      "= /api-docs/patch.json".alias = ../../../ragbv2/frontend/patch.json;
    };
  };

  systemd.services.django-ragb.serviceConfig = {
    LoadCredential = [
      "secret_key:${config.age.secrets.ragb.path}"
      "jwt_secret:${config.age.secrets.ragbJWT.path}"
    ];
    StateDirectory = "ragb";
    User = "ragb";
    Wants = [ "ragb-backend.service" ];
  };
  systemd.services.ragb-backend = {
    script = ''
      export JWT_SECRET=$(cat $CREDENTIALS_DIRECTORY/jwt_secret)
      export BK_FILE="$STATE_DIRECTORY/data.json"
      # export RUST_LOG=info
      ${pkgs.callPackage ../../../ragbv2/provisioning/backend.nix {}}/bin/ragb-backend
      '';
    serviceConfig = {
      StateDirectory = "ragb";
      LoadCredential = [
        "secret_key:${config.age.secrets.ragb.path}"
        "jwt_secret:${config.age.secrets.ragbJWT.path}"
      ];
      DynamicUser = true;
      User = "ragb";
    };
  };

  users.users.ragb.isSystemUser = true;
  users.users.ragb.group = "ragb";
  users.groups.ragb = {};
}
