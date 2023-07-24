{
  pkgs,
  config,
  lib,
  ...
}: {
  age.secrets = {
    "ntfy-passwd" = {
      file = ./ntfy.age;
      group = "ntfy-access";
      mode = "0440";
    };
  };
  users.groups."ntfy-access" = {};
}
