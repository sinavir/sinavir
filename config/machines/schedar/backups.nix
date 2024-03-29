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
  services.postgresql.ensureUsers = [
    {
      name = "root";
    }
  ];
  services.borgmatic = {
    enable = true;
    startAt = "*-*-* 20:00:00";
    configurations = {
      "netboxdb" = {
        ssh_command = "ssh -o 'UserKnownHostsFile ${knownHost}' -i ${config.age.secrets."bk-key".path}";
        source_directories = [
          "/var/lib/netbox"
        ];
        repositories = ["ssh://borg@${bkhost}/./netbox"];
        postgresql_databases = [
          { name = "netbox"; }
        ];
        keep_daily = 7;
        keep_weekly = 1;
        keep_monthly = 4;
        encryption_passcommand = "cat ${config.age.secrets."bk-passwd".path}";
      };
    };
  };
  systemd.services.borgmatic.path = [ config.services.postgresql.package ];

}
