# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../shared
    ./authelia.nix
    ./bootloader.nix
    ./hardware-configuration.nix
    ./kanidm.nix
    ./knot.nix
    ./headscale.nix
    ./mail.nix
    ./backups.nix
    ./radicale.nix
    ./networking.nix
    ./pass.nix
    ./secrets
    ./kfet-proxy
    ./linkal.nix
    ./static-website.nix
    ./thelounge.nix
  ];

  networking.hostName = "proxima"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
