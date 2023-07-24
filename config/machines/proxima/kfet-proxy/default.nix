{config, ...}: {
  services.nginx = {
    virtualHosts."kfet.sinavir.fr" = {
      enableACME = true;
      forceSSL = true;
      # TODO: put src in a git
      root = ./src;
      locations."/ws/" = {
        proxyPass = "https://cof.ens.fr/ws/k-fet/open/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host cof.ens.fr;
        '';
      };
    };
  };
}
