{ config, pkgs, lib, modulesPath, ... }: {
  imports = [(modulesPath + "/installer/netboot/netboot-minimal.nix")];
  # Early init the serial console
  boot.kernelParams = [ "console=tty1" "console=ttyS0,115200" ];

  # Some usefull options for setting up a new system
  services.getty.autologinUser = lib.mkForce "root";
  # Enable sshd which gets disabled by netboot-minimal.nix
  systemd.services.sshd.wantedBy = lib.mkOverride 0 [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keyFiles = [ ../../shared/pubkeys/maurice.keys ];
  programs.mosh.enable = true;

  console.keyMap = "fr";
  system.stateVersion = "23.11";
  nixpkgs.hostPlatform = "x86_64-linux";
}
