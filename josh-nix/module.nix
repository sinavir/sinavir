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

          This user will be the one you have to use
          in order to access filtered repos via ssh
          '';
        default = defaultUser;
      };
      group = lib.mkOption {
        type = lib.types.str;
        description = ''
          User account under which josh-proxy runs.

          This user will be the one you have to use
          in order to access filtered repos via ssh
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
      ssh = {
        enable = lib.mkEnableOption ''
          Add sshd config to support pulling repos in ssh.
          (Basically it adds some extra config for the josh user)

          Please keep in mind that it is STRONGLY NOT RECOMMENDED to activate
          this option if josh instance is public
          '';
        sshMaxStartups = lib.mkOption {
          type = lib.types.ints.poditive;
          description = "Maximum number of concurrent SSH authentication attempts.";
          default = 16;
        };
        sshTimeout = lib.mkOption {
          type = lib.types.ints.positive;
          description = "Timeout, in seconds, for a single request when serving repos over SSH. This time should cover fetch from upstream repo, filtering, and serving repo to client.";
          default = 300;
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
    services.openssh = lib.mkIf cfg.ssh.enable {
      extraConfig = let josh-auth-key = pkgs.writeShellApplication {
        name = "josh-auth-key";
        text = ''
          KEY_TYPE=''${1}
          KEY_FINGERPRINT=''${2}

          printf "%s %s" "''${KEY_TYPE}" "''${KEY_FINGERPRINT}"
          '';
      };
      in ''
        Match User ${cfg.user}
          LogLevel INFO

          AllowStreamLocalForwarding no
          AllowTcpForwarding no
          AllowAgentForwarding Yes
          PermitTunnel no
          # Important: prevent any interactive commands from execution
          PermitTTY no
          PermitUserEnvironment no
          PermitUserRC no
          X11Forwarding no
          PrintMotd no

          # Accepted environment variables

          AcceptEnv GIT_PROTOCOL

          # Client management
          ClientAliveInterval 360
          ClientAliveCountMax 0

          # Authentication
          PasswordAuthentication no
          HostbasedAuthentication no
          KbdInteractiveAuthentication no
          PermitRootLogin no
          PubkeyAuthentication yes
          AuthorizedKeysFile none

          AuthorizedKeysCommand ${josh-auth-key}/bin/josh-auth-key %t %k
          AuthorizedKeysCommandUser nobody
        '';
    };
  };
}
