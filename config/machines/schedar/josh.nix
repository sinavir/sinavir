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
    ssh = {
      enable = true;
      authorizedKeysFile = ./../../shared/pubkeys/maurice.keys;
    };
  };
  services.nginx.virtualHosts."josh.sinavir.fr" = {
    forceSSL = true;
    enableACME = true;
  };
}

