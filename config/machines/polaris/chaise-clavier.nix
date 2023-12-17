{
  config,
  pkgs,
  lib,
  ...
}: {
  services.physlock = {
    enable = true;
    allowAnyUser = true;
    lockMessage = "Screen is locked !";
  };
  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
        fira
        fira-code
        libertine
        source-serif-pro
        stix-two
        vistafonts
    ];

  services.printing.enable = true;
  hardware.sane.enable = true;
  users.users.maurice.extraGroups = ["scanner" "lp"];
  hardware.sane.extraBackends = [pkgs.sane-airscan];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
