{
  config,
  pkgs,
  lib,
  ...
}: {
  security.pam.services.swaylock = {};
  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  fonts.enableDefaultFonts = true;
  fonts.fonts = [pkgs.font-awesome pkgs.helvetica-neue-lt-std pkgs.aegyptus];

  services.printing.enable = true;
  hardware.sane.enable = true;
  users.users.maurice.extraGroups = ["scanner" "lp"];
  hardware.sane.extraBackends = [pkgs.sane-airscan];
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
}
