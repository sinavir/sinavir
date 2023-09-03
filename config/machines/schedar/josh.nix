{ lib, pkgs, config, ... }:
{
  imports = [ ../../../josh-nix/module.nix ];
  services.josh-proxy = {
    enable = true;
    settings.remotes = [ "https://github.com/sinavir" ];
    virtualHost = {
      enable = true;
      host = "josh.sinavir.fr";
    };
  };
  services.nginx.virtualHosts."josh.sinavir.fr" = {
    forceSSL = true;
    enableACME = true;
  };
}

