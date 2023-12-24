{
  config,
  lib, 
  pkgs,
  modulesPath,
  ...
}: let
  launchpad = 
    pkgs.python3.withPackages ( ps: [ (ps.callPackage ./launchpad.nix { lpminimk3 = ps.callPackage ./lpminimk3.nix {}; })]);
in
  {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    ./bootloader.nix
    ../../shared
    ./networking.nix
  ];

  nix.settings.substituters = lib.mkForce [];

  users.users.root.openssh.authorizedKeys.keyFiles = [ ./keys.keys ];

  networking.hostName = "rigel"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  environment.systemPackages = [
    launchpad
  ];

  systemd.services.launchpad = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ launchpad pkgs.unixtools.ping ];
    script = ''
      while ! ping -n -w 1 -c 1 10.1.1.2 &> /dev/null
      do
          echo "waiting eos"
      done
      sleep 0.1
      python -m eos_midi 10.1.1.2
      '';
  };
  environment.shellAliases = {
    r = "systemctl restart launchpad.service";
  };

  fonts.enableDefaultPackages = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?
}
