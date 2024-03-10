{
  pkgs,
  lib,
  config,
  ...
}: {
  services.headscale = {
    enable = true;
    port = 8085;
    address = "127.0.0.1";
    settings = {
      log.level = "debug";
      server_url = "https://vpn.sinavir.fr";
      #metrics_listen_addr = "127.0.0.1:8095";
      dns_config = {
        #magic_dns = true;
        override_local_dns = true;
        nameservers = ["1.1.1.1"];
        extra_records = [
          {
            name = "arkheon.vpn";
            type = "A";
            value = "100.64.0.2";
          }
        ];
      };

      ip_prefixes = [
        "100.64.0.0/10"
      ];
      oidc = {
        issuer = "https://auth.sinavir.fr";
        client_id = "headscale";
        client_secret_path = config.age.secrets."oidc_headscale_secret".path;
        #allowed_domains = [ "sinavir.fr" ];
        scope = ["openid" "profile" "email" "groups"];
        allowed_groups = [
          "headscale"
        ];
        extra_params.client_id = "headscale";
      };
    };
  };

  services.nginx.virtualHosts = {
    "vpn.sinavir.fr" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:${toString config.services.headscale.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
  environment.systemPackages = [pkgs.headscale];
}
