{ lib, pkgs, config, ... }:
{
  imports = [ ../../../nixexpr/josh/module.nix ];
  services.josh-proxy = {
    enable = false; # TODO fix josh build
    settings.remotes = [ "https://github.com/sinavir/sinavir" ];
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

