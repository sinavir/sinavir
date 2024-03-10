{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./noleds.nix
    ./bootloader.nix
    ./mimir.nix
    ./secrets
    ../../shared
    ./users.nix
    ./networking.nix
  ];

  networking.hostName = "capella"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  fonts.enableDefaultPackages = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
