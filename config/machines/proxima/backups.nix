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
  services.borgmatic = {
    enable = true;
    startAt = "*-*-* 20:10:00";
    configurations = {
      "mails" = {
        ssh_command = "ssh -o 'UserKnownHostsFile ${knownHost}' -i ${config.age.secrets."bk-key".path}";
        source_directories = [
          "/var/vmail"
        ];
        repositories = [{
          path= "ssh://borg@${bkhost}/./mails";
        }];
        keep_daily = 7;
        keep_weekly = 1;
        keep_monthly = 4;
        encryption_passcommand = "cat ${config.age.secrets."bk-passwd".path}";
      };
      "pass" = {
        ssh_command = "ssh -o 'UserKnownHostsFile ${knownHost}' -i ${config.age.secrets."bk-key".path}";
        source_directories = [
          "/var/lib/bitwarden_rs"
        ];
        repositories = ["ssh://borg@${bkhost}/./pass"];
        keep_daily = 7;
        keep_weekly = 1;
        keep_monthly = 4;
        encryption_passcommand = "cat ${config.age.secrets."bk-passwd".path}";
      };
    };
  };
}
