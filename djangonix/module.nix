{
  pkgs,
  lib,
  config,
  ...
}: let
  mkEnvFile = pkgs.callPackage ./utils/mkEnvFile.nix {};
  mkManagePy = pkgs.callPackage ./utils/mkManagePy.nix {};
  mkStaticAssets = {
    app,
    managePy,
  }:
    pkgs.runCommand "django-${app}-static" {} ''
      mkdir -p $out/static
      ${managePy.collectstatic}/bin/collectstatic $out/static
    '';
  djangoAppModule = lib.types.submodule ({
    config,
    name,
    ...
  }: {
    options = {
      enable = lib.mkEnableOption (lib.mdDoc "Enable django application");
      src = lib.mkOption {
        type = lib.types.path;
      };
      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = with lib.types; attrsOf anything;
          options = {
            STATIC_ROOT = lib.mkOption {
              type = lib.types.path;
              default = builtins.toString config.staticAssets;
            };
          };
        };
      };
      envPrefix = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "MYAPP_";
        description = "A prefix to prepend to all setttings passed as environnement variables.";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 51666;
      };
      processes = lib.mkOption {
        type = lib.types.int;
        default = 2;
      };
      threads = lib.mkOption {
        type = lib.types.int;
        default = 2;
      };
      envFile = lib.mkOption {
        type = lib.types.path;
        default = mkEnvFile {
          inherit (config) envPrefix settings;
          app = name;
        };
        internal = true;
      };
      staticAssets = lib.mkOption {
        type = lib.types.path;
        default = mkStaticAssets {
          inherit (config) managePy;
          app = name;
        };
        description = "Satic assets to be served directly by nginx. The default value should be good enough in most cases.";
      };
      manageFilePath = lib.mkOption {
        type = lib.types.str;
        default = "${name}/manage.py";
        description = "Path relative to src pointing to manage.py file";
      };
      pythonPackage = lib.mkOption {
        type = lib.types.path;
        default = pkgs.python3.withPackages (ps: [ps.django]);
      };
      managePy = lib.mkOption {
        type = lib.types.attrs;
        default = mkManagePy {
          inherit (config) pythonPackage envPrefix manageFilePath src envFile;
          app = name;
        };
      };
    };
  });
in {
  options = {
    services.django = lib.mkOption {
      type = lib.types.attrsOf djangoAppModule;
      description = "Attribute set of djanfo app modules";
    };
  };
  config.systemd.services = lib.mapAttrs' (
    app: cfg:
      lib.nameValuePair "django-${app}"
      (lib.mkIf cfg.enable {
        description = "${app} django service";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        serviceConfig = {
          DynamicUser = true;
        };
        script = ''
          source ${cfg.envFile}
          ${cfg.managePy.managePy}/bin/manage-${app} migrate
          ${cfg.pythonPackage}/bin/gunicorn ${app}.wsgi \
              --pythonpath ${cfg.src}/${app} \
              -b 127.0.0.1:${toString cfg.port} \
              --workers=${toString cfg.processes} \
              --threads=${toString cfg.threads}
        '';
      })
  ) config.services.django;
}
