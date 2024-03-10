{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.services.tandoor-recipes;
in
{
  services.tandoor-recipes = {
    package = pkgs.tandoor-recipes.overrideAttrs ({
      postConfigure = ''
        echo "ACCOUNT_SESSION_REMEMBER = True" >> ./recipes/settings.py
      '';
    });
    enable = true;
    extraConfig = {
      SECRET_KEY_FILE = "%d/secret_key";
      ALLOWED_HOSTS="tandoor.sinavir.fr";
      DATABASE_URL = "sqlite:// //var/lib/tandoor-recipes/db.sqlite";
      MEDIA_ROOT = "/var/lib/tandoor-recipes/media/";
      SOCIAL_PROVIDERS = "allauth.socialaccount.providers.openid_connect";
    };
  };
  systemd.services.tandoor-recipes.serviceConfig = {
    EnvironmentFile = config.age.secrets.tandoorEnv.path;
    LoadCrendential = [
      "secret_key:${config.age.secrets.tandoorSecret.path}"
    ];
  };
  services.nginx = {
    enable = true;
    virtualHosts."tandoor.sinavir.fr" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://${cfg.address}:${builtins.toString cfg.port}";
      locations."/static/".alias = "${cfg.package}/lib/tandoor-recipes/staticfiles/";
      locations."/media/".alias = cfg.extraConfig.MEDIA_ROOT;
    };
  };
}
