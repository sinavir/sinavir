{
  pkgs,
  config,
  lib,
  ...
}: {
  age.secrets."wg-polaris".file = ./wg-polaris.age;
  age.secrets."bk-passwd".file = ./bk-passwd.age;
  age.secrets."bk-key".file = ./bk-key.age;
}
