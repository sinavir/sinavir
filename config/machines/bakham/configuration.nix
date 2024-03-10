{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
  {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix") # this holds the hardware-config
    ./bootloader.nix
    ./secrets
    ../../shared/minimal-shared.nix
    ./networking.nix
  ];

  nix.settings.substituters = lib.mkForce [];

  users.users.root.openssh.authorizedKeys.keyFiles = [ ./keys.keys ];

  networking.hostName = "bakham"; # Define your hostname.

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "run-gw";
      runtimeInputs = [
        pkgs.curl
        (pkgs.callPackage ../../../ragbv2/provisioning/python.nix {})
      ];
      text = "curl -s -n https://agb.hackens.org/api/sse | python ${../../../ragbv2/client/script.py}";
    })
  ];

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  fonts.enableDefaultPackages = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?
}
