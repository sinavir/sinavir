{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.borgmatic;
  settingsFormat = pkgs.formats.yaml {};
  mkConfigDir = name: entries: let
    linkCommands =
      lib.mapAttrsToList (name: path: ''
        ln -s ${lib.escapeShellArg "${path}"} ${lib.escapeShellArg "${name}"}
      '')
      entries;
  in
    pkgs.runCommand name {
      preferLocalBuild = true;
      allowSubstitutes = false;
      passthru.entries = entries;
      nativeBuildInputs = [pkgs.borgmatic];
    } ''
      mkdir -p $out
      cd $out
      ${lib.concatStrings linkCommands}
      ${cfg.preValidationScript}
      validate-borgmatic-config -c $out
    '';

  configDir = mkConfigDir "borgmatic-config" (
    mapAttrs'
    (
      name: value:
        nameValuePair
        "${name}.yaml"
        (settingsFormat.generate "${name}.yaml" value)
    )
    cfg.configurations
  );
in {
  disabledModules = ["services/backup/borgmatic.nix"];

  options.services.borgmatic = {
    enable = mkEnableOption (lib.mdDoc "borgmatic");

    startAt = lib.mkOption {
      type = types.str;
      default = "hourly";
      description = "Schedule for the backups.";
    };

    beforeAllScript = lib.mkOption {
      type = types.str;
      default = "";
    };

    preValidationScript = lib.mkOption {
      type = types.str;
      default = "";
    };

    configurations = mkOption {
      description = lib.mdDoc ''
        See https://torsion.org/borgmatic/docs/reference/configuration/
      '';
      default = {};
      type = with types;
        attrsOf (submodule {
          freeformType = settingsFormat.type;
          options.location = {
            source_directories = mkOption {
              type = listOf str;
              description = lib.mdDoc ''
                List of source directories to backup (required). Globs and
                tildes are expanded.
              '';
              example = ["/home" "/etc" "/var/log/syslog*"];
            };
            repositories = mkOption {
              type = listOf str;
              description = lib.mdDoc ''
                Paths to local or remote repositories (required). Tildes are
                expanded. Multiple repositories are backed up to in
                sequence. Borg placeholders can be used. See the output of
                "borg help placeholders" for details. See ssh_command for
                SSH options like identity file or port. If systemd service
                is used, then add local repository paths in the systemd
                service file to the ReadWritePaths list.
              '';
              example = [
                "user@backupserver:sourcehostname.borg"
                "user@backupserver:{fqdn}"
              ];
            };
          };
        });
    };
  };

  config = mkIf cfg.enable {
    systemd.services."borgmatic" = {
      enable = true;
      description = "Borgmatic backups service";
      wants = ["network-online.service"];
      after = ["network-online.service"];
      startAt = cfg.startAt;
      serviceConfig = {
        Type = "oneshot";
        # Security settings for systemd running as root, optional but recommended to improve security. You
        # can disable individual settings if they cause problems for your use case. For more details, see
        # the systemd manual: https://www.freedesktop.org/software/systemd/man/systemd.exec.html
        LockPersonality = true;
        # Certain borgmatic features like Healthchecks integration need MemoryDenyWriteExecute to be off.
        # But you can try setting it to "yes" for improved security if you don't use those features.
        MemoryDenyWriteExecute = false;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        SystemCallErrorNumber = "EPERM";
        # To restrict write access further, change "ProtectSystem" to "strict" and uncomment
        # "ReadWritePaths", "ReadOnlyPaths", "ProtectHome", and "BindPaths". Then add any local repository
        # paths to the list of "ReadWritePaths" and local backup source paths to "ReadOnlyPaths". This
        # leaves most of the filesystem read-only to borgmatic.
        ProtectSystem = "full";
        # ReadWritePaths=-/mnt/my_backup_drive
        # ReadOnlyPaths=-/var/lib/my_backup_source
        # This will mount a tmpfs on top of /root and pass through needed paths;
        # ProtectHome=tmpfs
        # May interfere with running external programs within borgmatic hooks.
        # CapabilityBoundingSet="CAP_DAC_READ_SEARCH CAP_NET_RAW";
        # Lower CPU and I/O priority.
        Nice = 19;
        CPUSchedulingPolicy = "batch";
        IOSchedulingClass = "best-effort";
        IOSchedulingPriority = 7;
        IOWeight = 100;
        Restart = "no";
        # Prevent rate limiting of borgmatic log events. If you are using an older version of systemd that
        # doesn't support this (pre-240 or so), you may have to remove this option.
        LogRateLimitIntervalSec = 0;
        # Delay start to prevent backups running during boot. Note that systemd-inhibit requires dbus and
        # dbus-user-session to be installed.
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 1m";
        # Original line, to see if it is worth: ExecStart="systemd-inhibit --who="borgmatic" --what="sleep:shutdown" --why="Prevent interrupting scheduled backup" ${borgmatic}/bin/borgmatic --verbosity -1 --syslog-verbosity 1";
      };
      script = ''
        ${cfg.beforeAllScript}
        ${pkgs.borgmatic}/bin/borgmatic rcreate -e repokey -c ${configDir} -v 2
        ${pkgs.borgmatic}/bin/borgmatic -c ${configDir}
      '';
    };
  };
}
