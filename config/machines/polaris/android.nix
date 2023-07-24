{pkgs, ...}: {
  users.users.maurice.extraGroups = ["adbusers"];
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
}
