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
      ensurePermissions = {
        "DATABASE netbox" = "CONNECT";
        "ALL TABLES IN SCHEMA public" = "SELECT";
      };
    }
  ];
  services.borgmatic = {
    enable = true;
    startAt = "*-*-* 20:10:00";
    configurations = {
      "mails" = {
        storage.ssh_command = "ssh -o 'UserKnownHostsFile ${knownHost}' -i ${config.age.secrets."bk-key".path}";
        location.source_directories = [
          "/var/vmail"
        ];
        location.repositories = ["ssh://borg@${bkhost}/./mails"];
        retention = {
          keep_daily = 7;
          keep_weekly = 1;
          keep_monthly = 4;
        };
        storage.encryption_passcommand = "cat ${config.age.secrets."bk-passwd".path}";
      };
    };
  };
}
