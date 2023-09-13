{
  pkgs,
  lib,
  config,
  ...
}: {
  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
      forceSSL = true;
      enableACME = true;
      root = "${pkgs.lychee}/public/";
      locations = {
        "^~ /index.php" = {
          fastcgiParams = {
            SCRIPT_FILENAME = "$document_root$fastcgi_script_name";
          };
          extraConfig = ''
            fastcgi_split_path_info ^(.+?\.php)(/.*)$;
            fastcgi_pass unix:${
              config.services.phpfpm.pools."lychee".socket
            };
            fastcgi_index index.php;
            client_max_body_size 100M;
          '';
        };
        "~ [^/].php(/|$)" = {return = "403";};
      };
      extraConfig = ''
        index index.php;
        if (!-e $request_filename)
        {
            rewrite ^/(.*)$ /index.php?/$1 last;
            break;
        }
      '';
    };
  };
  services.phpfpm.pools."lychee" = {
    user = config.services.nginx.user;
    group = config.services.nginx.group;
    phpPackage = pkgs.php81.withExtensions ({
      enabled,
      all,
    }:
      enabled ++ [all.imagick all.bcmath all.mbstring all.gd]);
    phpOptions = ''
      upload_max_filesize = 100M
      post_max_size = 100M
    '';
    settings = {
      "pm" = "dynamic";
      "pm.max_children" = 75;
      "pm.start_servers" = 10;
      "pm.min_spare_servers" = 5;
      "pm.max_spare_servers" = 20;
      "pm.max_requests" = 500;
      "listen.owner" = config.services.nginx.user;
      "listen.group" = config.services.nginx.group;
    };
    phpEnv."PATH" = lib.makeBinPath [pkgs.ffmpeg];
  };
  networking.firewall.allowedTCPPorts = [80 443];
}
