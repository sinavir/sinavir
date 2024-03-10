{ config, ... }:

let
  domain = "sso.sinavir.fr";

  cert = config.security.acme.certs.${domain};

  allowedSubDomains = [
    "auth"
    "tandoor"
  ];
in
{
  services.kanidm = {
    enableServer = true;

    serverSettings = {
      inherit domain;

      origin = "https://${domain}";

      bindaddress = "127.0.0.1:8447";
      #ldapbindaddress = "0.0.0.0:636";

      trust_x_forward_for = true;

      tls_chain = "${cert.directory}/fullchain.pem";
      tls_key = "${cert.directory}/key.pem";
    };
  };

  users.users.kanidm.extraGroups = [ cert.group ];

  services.nginx = {
    enable = true;

    virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "https://127.0.0.1:8447";

#        extraConfig = ''
#          if ( $request_method !~ ^(GET|POST|HEAD|OPTIONS|PUT|PATCH|DELETE)$ ) {
#              return 444;
#          }
#
#          set $origin $http_origin;
#
#          if ($origin !~ '^https?://(${builtins.concatStringsSep "|" allowedSubDomains})\.dgnum\.eu$') {
#              set $origin 'https://${domain}';
#          }
#
#          proxy_hide_header Access-Control-Allow-Origin;
#
#          if ($request_method = 'OPTIONS') {
#              add_header 'Access-Control-Allow-Origin' "$origin" always;
#              add_header 'Access-Control-Allow-Methods' 'GET, POST, PATCH, PUT, DELETE, OPTIONS' always;
#              add_header 'Access-Control-Allow-Headers' 'Content-Type, Accept, Authorization' always;
#              add_header 'Access-Control-Allow-Credentials' 'true' always;
#
#              add_header Access-Control-Max-Age 1728000;
#              add_header Content-Type 'text/plain charset=UTF-8';
#              add_header Content-Length 0;
#              return 204;
#          }
#
#          if ($request_method ~ '(GET|POST|PATCH|PUT|DELETE)') {
#              add_header Access-Control-Allow-Origin "$origin" always;
#              add_header Access-Control-Allow-Methods 'GET, POST, PATCH, PUT, DELETE, OPTIONS' always;
#              add_header Access-Control-Allow-Headers 'Content-Type, Accept, Authorization' always;
#              add_header Access-Control-Allow-Credentials true always;
#          }
#        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 636 ];
  networking.firewall.allowedUDPPorts = [ 636 ];
}
