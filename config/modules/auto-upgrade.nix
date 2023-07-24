{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.system.autoUpgradeWithHooks;
in {
  options = {
    system.autoUpgradeWithHooks = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to periodically upgrade NixOS to the latest
          version. If enabled, a systemd timer will run
          `nixos-rebuild switch` once a
          day.
        '';
      };

      operation = mkOption {
        type = types.enum ["switch" "boot"];
        default = "switch";
        example = "boot";
        description = lib.mdDoc ''
          Whether to run
          `nixos-rebuild switch` or run
          `nixos-rebuild boot`
        '';
      };

      flake = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "github:kloenk/nix";
        description = lib.mdDoc ''
          The Flake URI of the NixOS configuration to build.
          Disables the option {option}`system.autoUpgradeWithHooks.channel`.
        '';
      };

      flags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [
          "-I"
          "stuff=/home/alice/nixos-stuff"
          "--option"
          "extra-binary-caches"
          "http://my-cache.example.org/"
        ];
        description = lib.mdDoc ''
          Any additional flags passed to {command}`nixos-rebuild`.

          If you are using flakes and use a local repo you can add
          {command}`[ "--update-input" "nixpkgs" "--commit-lock-file" ]`
          to update nixpkgs.
        '';
      };

      dates = mkOption {
        type = types.str;
        default = "04:40";
        example = "daily";
        description = lib.mdDoc ''
          How often or when upgrade occurs. For most desktop and server systems
          a sufficient upgrade frequency is once a day.

          The format is described in
          {manpage}`systemd.time(7)`.
        '';
      };

      allowReboot = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Reboot the system into the new generation instead of a switch
          if the new generation uses a different kernel, kernel modules
          or initrd than the booted system.
          See {option}`rebootWindow` for configuring the times at which a reboot is allowed.
        '';
      };

      randomizedDelaySec = mkOption {
        default = "0";
        type = types.str;
        example = "45min";
        description = lib.mdDoc ''
          Add a randomized delay before each automatic upgrade.
          The delay will be chosen between zero and this value.
          This value must be a time span in the format specified by
          {manpage}`systemd.time(7)`
        '';
      };

      rebootWindow = mkOption {
        description = lib.mdDoc ''
          Define a lower and upper time value (in HH:MM format) which
          constitute a time window during which reboots are allowed after an upgrade.
          This option only has an effect when {option}`allowReboot` is enabled.
          The default value of `null` means that reboots are allowed at any time.
        '';
        default = null;
        example = {
          lower = "01:00";
          upper = "05:00";
        };
        type = with types;
          nullOr (submodule {
            options = {
              lower = mkOption {
                description = lib.mdDoc "Lower limit of the reboot window";
                type = types.strMatching "[[:digit:]]{2}:[[:digit:]]{2}";
                example = "01:00";
              };

              upper = mkOption {
                description = lib.mdDoc "Upper limit of the reboot window";
                type = types.strMatching "[[:digit:]]{2}:[[:digit:]]{2}";
                example = "05:00";
              };
            };
          });
      };

      persistent = mkOption {
        default = true;
        type = types.bool;
        example = false;
        description = lib.mdDoc ''
          Takes a boolean argument. If true, the time when the service
          unit was last triggered is stored on disk. When the timer is
          activated, the service unit is triggered immediately if it
          would have been triggered at least once during the time when
          the timer was inactive. Such triggering is nonetheless
          subject to the delay imposed by RandomizedDelaySec=. This is
          useful to catch up on missed runs of the service when the
          system was powered down.
        '';
      };

      preRebuildHook = mkOption {
        default = "";
        type = types.str;
        description = lib.mdDoc ''
          A hook that will be activated after switching to configuration (not
          executed in case of a reboot)
        '';
      };

      postSwitchHook = mkOption {
        default = "";
        type = types.str;
        description = lib.mdDoc ''
          A hook that will be activated after switching to configuration (not
          executed in case of a reboot)
        '';
      };

      outsideOfRebootWindowHook = mkOption {
        default = "";
        type = types.str;
        description = lib.mdDoc ''
          A hook that will be activated if a reboot is needed but current time is outside of reboot window
        '';
      };

      preShutdownHook = mkOption {
        default = "";
        type = types.str;
        description = lib.mdDoc ''
          A hook that will be activated before rebooting the machine
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nixos-upgrade-with-hooks = {
      description = "NixOS Upgrade";

      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;

      serviceConfig.Type = "oneshot";

      environment =
        config.nix.envVars
        // {
          inherit (config.environment.sessionVariables) NIX_PATH;
          HOME = "/root";
        }
        // config.networking.proxy.envVars;

      path = with pkgs; [
        coreutils
        gnutar
        xz.bin
        gzip
        gitMinimal
        config.nix.package.out
        config.programs.ssh.package
      ];

      script = let
        nixos-rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
        date = "${pkgs.coreutils}/bin/date";
        readlink = "${pkgs.coreutils}/bin/readlink";
        shutdown = "${config.systemd.package}/bin/shutdown";
      in ''
        ${cfg.preRebuildHook}
        ${nixos-rebuild} ${cfg.operation} ${toString cfg.flags}
        ${cfg.postSwitchHook}
      '';

      startAt = cfg.dates;

      after = ["network-online.target"];
      wants = ["network-online.target"];
    };

    systemd.timers.nixos-upgrade-with-hooks = {
      timerConfig = {
        RandomizedDelaySec = cfg.randomizedDelaySec;
        Persistent = cfg.persistent;
      };
    };
  };
}
