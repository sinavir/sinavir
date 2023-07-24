{ pkgs, lib, config, ... }:
{
  services.netbox = {
    enable = true;
    secretKeyFile = config.age.secrets."netbox".path;
    listenAddress = "127.0.0.1";
  };
  systemd.services.netbox.serviceConfig.TimeoutStartSec = 180;
  services.nginx = {
    enable = true;
    virtualHosts."netbox.dgnum.sinavir.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.services.netbox.listenAddress}:${builtins.toString config.services.netbox.port}";
      locations."/static/".alias = "${config.services.netbox.dataDir}/static/";
    };
  };
  users.users.nginx.extraGroups = ["netbox"];
  networking.firewall.allowedTCPPorts = [ 443 80 ];
}
