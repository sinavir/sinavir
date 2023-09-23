{ pkgs, lib, config, ...}:
let
  defaultUser = "josh-git";
  cfg = config.services.josh-proxy;
in
{
  options = {
    services.josh-proxy = {
      enable = lib.mkEnableOption "Enable josh-proxy";
      user = lib.mkOption {
        type = lib.types.str;
        description = ''
          User account under which josh-proxy runs.
          '';
        default = defaultUser;
      };
      group = lib.mkOption {
        type = lib.types.str;
        description = ''
          Group under which josh-proxy runs.
          '';
        default = defaultUser;
      };
      # Even if there is no configuration file I add a settings section that will hold config options (those in ![container configuration](https://josh-project.github.io/josh/reference/container.html))
      settings = {
        remotes = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "The upstream http(s) or ssh remotes. (at most one of each, else josh-proxy will fail)";
          example = [ "https://github.com" "ssh://git@github.com" ];
        };
        httpPort = lib.mkOption {
          type = lib.types.port;
          description = "HTTP port to listen on.";
          default = 8000;
        };
        extraOpts = lib.mkOption {
          type = lib.types.str;
          description = "Extra options passed directly to `josh-proxy` process.";
          default = "";
        };
      };
      virtualHost = {
        enable = lib.mkEnableOption "Add a nginx virtualHost configuration. Further configuration can be done through services.nginx.virtualHosts (to enable TLS for instance).";
        host = lib.mkOption {
          type = lib.types.str;
          description = "vhost url";
          default = "";
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.josh-proxy = {
      description = "JOSH proxy server.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = let options = [
        "--gc"
        "--local=$STATE_DIRECTORY"
        "--port=${builtins.toString cfg.settings.httpPort}"
        cfg.settings.extraOpts
      ] ++ builtins.map (remote: "--remote=${remote}") cfg.settings.remotes;
      in "${pkgs.josh}/bin/josh-proxy ${lib.concatStringsSep " " options}";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        StateDirectory="josh-proxy";
        Restart = "on-failure";
        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
      };
    };
    services.nginx = lib.mkIf cfg.virtualHost.enable {
      virtualHosts.${cfg.virtualHost.host} = {
        locations = {
          "/" = {
            proxyPass = "http://localhost:${builtins.toString cfg.settings.httpPort}";
          };
          "/repo_upgrade" = {
            return = "404";
          };
          "/serve_namespace" = {
            return = "404";
          };
          "/~/ui/" = {
            alias = pkgs.josh.web;
          };
        };
      };
    };
    users.users = lib.mkIf (cfg.user == defaultUser) {
      ${cfg.user} = {
        shell = pkgs.josh;
        isSystemUser = true;
        group = cfg.group;
      };
    };
    users.groups = lib.mkIf (cfg.group == defaultUser) {
      ${cfg.group} = {};
    };
  };
}
