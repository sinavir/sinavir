let
  sources = import ./npins;

  agenix = sources.agenix + "/modules/age.nix";
  snm = sources.nixos-mailserver + "/default.nix";
  home-manager = sources.home-manager + "/nixos";

  metadata = {
    nodes = {
      polaris = {
        deployment = {
          targetHost = null;
          allowLocalDeployment = true;
          tags = [ "real" ];
        };
        imports = [agenix home-manager];
      };
      proxima = {
        deployment = {
          targetHost = "proxima";
          tags = [ "real" ];
        };
        imports = [snm agenix];
      };
      algedi = {
        deployment = {
          targetHost = "algedi.sinavir.fr";
          tags = [ "real" ];
        };
        imports = [agenix];
      };
      schedar = {
        deployment = {
          targetHost = "schedar";
          tags = [ "real" ];
        };
        imports = [agenix];
      };
      capella = {
        deployment = {
          targetHost = "capella";
          #buildOnTarget = true;
          tags = [ "real" ];
        };
        imports = [agenix];
        arch = "aarch64-linux";
      };
      rigel = {
        deployment = {
          #buildOnTarget = true;
          targetHost = "10.1.1.1";
          tags = [ "image" ];
        };
        imports = [agenix];
        arch = "aarch64-linux";
      };
      bakham = {
        deployment = {
          targetHost = "10.10.10.5";
          tags = [ "real" ];
        };
        imports = [agenix];
        arch = "aarch64-linux";
      };
      nekkar = {
        deployment = {
          targetHost = null;
          tags = [ "image" ];
        };
        nixpkgs = "nixos-netboot"; # overriding nixos for netboot as it takes time to build
      };
    };
  };
in
  metadata
