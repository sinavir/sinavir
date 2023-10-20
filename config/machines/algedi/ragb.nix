{ lib, pkgs, config, ... }:
{
  imports = [ ../../../djangonix/module.nix ];
  services.django.ragb = {
    enable = true;
    src = ../../../ragb;
    settings = {
      SECRET_KEY_FILE = "$CREDENTIALS_DIRECTORY/secret_key";
      DEV_KEY_FILE = "$CREDENTIALS_DIRECTORY/dev_key";
      DEBUG = false;
      REDIS_URI = "unix://${config.services.redis.servers.ragb.unixSocket}?db=0";
      WEBSOCKET_PORT = 9992;
      WEBSOCKET_HOST = "localhost";
      WEBSOCKET_ENDPOINT = "wss://agb.sinavir.fr/ws";
      ALLOWED_HOSTS = [ "127.0.0.1" "agb.sinavir.fr" "agb.hackens.org" ];
      DB_ENGINE = "django.db.backends.postgresql";
      DB_NAME = "ragb";
    };
    envPrefix = "";
    processes = 8;
    threads = 16;
    port = 9991;
    pythonPackage = pkgs.callPackage ../../../ragb/provisioning/python.nix {};
  };
  services.nginx.virtualHosts."agb.sinavir.fr" = {
    forceSSL = true;
    enableACME = true;
    serverAliases = [ "agb.hackens.org" ];
    locations = {
      "/" = {
        proxyPass = "http://localhost:9991/";
      };
      "/ws" = {
        proxyPass = "http://localhost:9992/";
        proxyWebsockets = true;
      };
      "/static".root = config.services.django.ragb.staticAssets;
    };
  };

  systemd.services.django-ragb.serviceConfig = {
    LoadCredential = [
      "secret_key:${config.age.secrets.ragb.path}"
      "dev_key:${config.age.secrets.ragb_devkey.path}"
    ];
    User = "ragb";
    Wants = [ "ragb-websocket.service" ];
  };
  systemd.services.ragb-websocket = {
    script = ''
      source ${config.services.django.ragb.envFile}
      ${config.services.django.ragb.pythonPackage}/bin/python ${config.services.django.ragb.src}/ragb/websocket_server.py
      '';
    serviceConfig = {
      DynamicUser = true;
      User = "ragb";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "ragb" ];
    ensureUsers = [
      {
        name = "ragb";
        ensurePermissions = {
          "DATABASE ragb" = "ALL PRIVILEGES";
        };
      }
    ];
  };
  services.redis.servers.ragb = {
    enable = true; 
    settings = {
      enable-protected-configs = true;
      enable-debug-command = true;
      enable-module-command = true;
      databases = lib.mkForce 1;
      save = lib.mkForce [];
    };
  };
  users.groups."${config.services.redis.servers.ragb.user}".members = [ "ragb" ];

  users.users.ragb.isSystemUser = true;
  users.users.ragb.group = "ragb";
  users.groups.ragb = {};
}
