{
  pkgs,
  config,
  lib,
  ...
}: {
  systemd.services.kfet-open-recorder = {
    script = ''
      ${pkgs.ws-scraper}/bin/ws-scraper \
        wss://cof.ens.fr/ws/k-fet/open \
        $STATE_DIRECTORY/db.sqlite
    '';
    serviceConfig = {
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
      StateDirectory = "kfet-open-recorder";
    };
  };
}
