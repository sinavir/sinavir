{
  pkgs,
  config,
  ...
}: let
  hostname = config.networking.hostName;
in {
  imports = [
    ../modules/auto-upgrade.nix
    ./secrets
  ];
  system.autoUpgradeWithHooks = {
    enable = true;
    dates = "22:00";
    preRebuildHook = ''
      ${pkgs.git}/bin/git -C /etc/nixos checkout main
      checkoutstatus=$?
      ${pkgs.git}/bin/git -C /etc/nixos pull https://github.com/sinavir/nixos_config.git
      fetchstatus=$?
    '';
    postSwitchHook = ''
      exitstatus=$?
      NTFY_PASS=$(cat ${config.age.secrets."ntfy-passwd".path})
      ${pkgs.curl}/bin/curl \
        -u misc:$NTFY_PASS \
        -H "Title: Rebuild for ${hostname}" \
        -d "checkout: $checkoutstatus / pull: $fetchstatus / rebuild: $exitstatus" \
        https://ntfy.sinavir.fr/server-daily-rebuild
    '';
  };
}
