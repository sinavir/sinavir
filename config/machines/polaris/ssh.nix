{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.ssh.startAgent = true;
  services.openssh.settings.PermitRootLogin = "no";
}
