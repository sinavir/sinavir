{
  pkgs,
  lib,
  config,
  ...
}: {
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 900;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 120;
        command = ''swaymsg "output * dpms off"'';
        resumeCommand = ''swaymsg "output * dpms on"'';
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
  };
}
