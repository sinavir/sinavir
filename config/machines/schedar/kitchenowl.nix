{ config, pkgs, ... }: {
  imports = [ ../../../nixexpr/kitchenowl/module.nix ];
  services.kitchenowl = {
    enable = true;
    secretKeyPath = config.age.secrets.kitchenowl.path;
  };
  services.nginx = {
    enable = true;
    virtualHosts."kitchenowl.sinavir.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/".extraConfig = ''
        include ${pkgs.nginx}/conf/uwsgi_params;
        uwsgi_pass uwsgi://127.0.0.1:5000;
        '';
    };
  };
}
