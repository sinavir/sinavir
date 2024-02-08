{
  config,
  pkgs,
  lib,
  ...
}: let
  bkhost = "capella.server";
  knownHost = pkgs.writeText "known_host" "${bkhost} ${builtins.readFile ../../shared/pubkeys/capella.keys}";
in {
  imports = [../../modules/borgmatic.nix];
  services.btrbk = {
    instances = {
      btrbk = {
        onCalendar = "*-*-* *:00/2:00";
        settings = {
          snapshot_preserve_min = "1d";
          snapshot_preserve = "7d 4w 12m";
          volume."/mnt/btrfs-home-top-lvl" = {
            subvolume = "home";
            snapshot_dir = "btrbk_snapshots";
          };
        };
      };
    };
  };
  services.borgmatic = {
    enable = true;
    startAt = "daily";
    configurations = {
      "home" = {
        ssh_command = "ssh -o 'UserKnownHostsFile ${knownHost}' -i ${config.age.secrets."bk-key".path}";
        source_directories = [
          "/mnt/btrfs-home-top-lvl/home-borgmatic-snapshot"
          "/etc/ssh"
          "/etc/NetworkManager/system-connections/"
          "/var/lib/paperless"
        ];
        repositories = [
          "ssh://borg@${bkhost}/./polaris-home"
        ];
        exclude_if_present = [".nobackup"];
        keep_daily = 1;
        keep_weekly = 1;
        keep_monthly = 4;
        encryption_passcommand = "cat ${config.age.secrets."bk-passwd".path}";

        before_backup = [
          (pkgs.writeScript "home-backup-prepare.sh" ''
            if [ -e /mnt/btrfs-home-top-lvl/home-borgmatic-snapshot ]
            then
              ${pkgs.btrfs-progs}/bin/btrfs subvolume delete -c /mnt/btrfs-home-top-lvl/home-borgmatic-snapshot
            fi
            ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /mnt/btrfs-home-top-lvl/home /mnt/btrfs-home-top-lvl/home-borgmatic-snapshot
          '')
        ];
        after_everything = [
          "${pkgs.btrfs-progs}/bin/btrfs subvolume delete /mnt/btrfs-home-top-lvl/home-borgmatic-snapshot"
        ];
      };
    };
  };
}
