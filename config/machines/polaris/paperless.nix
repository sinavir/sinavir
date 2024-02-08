{
  pkgs,
  lib,
  config,
  ...
}: {
  services.paperless = {
    enable = true;
    passwordFile = pkgs.writeText "password" "admin";
    settings = {
      PAPERLESS_ADMIN_USER = "admin";
      PAPERLESS_CONSUMER_RECURSIVE = "true";
    };
    address = "100.64.0.1";
  };
  services.redis.servers.paperless.settings = {
    enable-protected-configs = true;
    enable-debug-command = true;
    enable-module-command = true;
  };
}
