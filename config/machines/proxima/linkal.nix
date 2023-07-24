{
  pkgs,
  lib,
  config,
  ...
}: let
  linkal = with pkgs;
    rustPlatform.buildRustPackage rec {
      pname = "linkal";
      version = "0.1.0";

      src = fetchFromGitHub {
        owner = "JulienMalka";
        repo = "Linkal";
        rev = "354b464cd6b6263f41b19ba05ab5163d0e8203db";
        hash = "sha256-hlZlGblw7PDRlC4dBJVC3hwy+HZbXC+Mq4jbXP94ya4=";
      };
      cargoHash = "sha256-cA2R8ID1Dq7Da6MrbKit6UkJ2/SZ6abgyS4kfqAsUEM=";
    };
  calConf = let
    mapAddPrefix = pref:
      lib.mapAttrs' (n: value: {
        name = pref + n;
        inherit value;
      });
  in {
    "calendars" = mapAddPrefix "https://cloud.eleves.ens.fr/remote.php/dav/public-calendars/" {
      "fRtjDkjrZyn6fxd8" = {
        "name" = "K-Fêt";
      };
      "gsZtZK8c9EmREofn" = {
        "name" = "Ernestophone";
      };
      "dTHrXnYgsEoSTjWB" = {
        "name" = "Évènements (COF)";
      };
      "bCgRFByHLiCCNc55" = {
        "name" = "Assemblées Générales (COF)";
      };
      "r4yJZDHjwNtH8wkR" = {
        "name" = "BdA";
      };
    } // mapAddPrefix "https://framagenda.org/remote.php/dav/public-calendars/" {
      "dSYCtdC6bgyWpKyt" = {
        "name" = "BDS";
      };
    };
  };
in {
  services.nginx = {
    enable = true;
    virtualHosts."rz.sinavir.fr" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:8443/";
        };
      };
    };
    virtualHosts."pub.calendar.sinavir.fr" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:8443/";
        };
      };
    };
  };
  systemd.services.linkal = {
    script = "${linkal}/bin/linkal --calendar-file ${pkgs.writeText "calendars.json" (builtins.toJSON calConf)}";
    description = "linkal";
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
    serviceConfig = {
      DynamicUser = true;
    };
  };
}
