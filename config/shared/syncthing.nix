{config, ...}:
# TODO put secrets in agenix to lose some state
let
  enabledHosts = [
    "polaris"
  ];
in {
  services.syncthing = rec {
    enable = builtins.elem config.networking.hostName enabledHosts;
    devices.sirius.id = "EAXHMJI-NNCZVVN-FHXRGAJ-VBSRP2K-HVVS75F-7AGJU26-ENW4I3G-FGDCMA6";
    devices.polaris.id = "QMJEDQK-KMFJFB3-G7LID3Z-NXUHLES-4BGJCUJ-IKK4WXI-YN3GLG7-E7IGHAG";
    # TODO add capella
    folders = {
      Notes = {
        id = "75ujo-go7am";
        devices = ["sirius" "polaris"];
        path = "~/Notes";
      };
    };
  };
}
