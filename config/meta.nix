let
  sources = import ./npins;

  agenix = sources.agenix + "/modules/age.nix";
  home-manager = sources.home-manager + "/nixos";

  metadata = {
    nodes = {
      polaris = {
        deployment = {
          targetHost = null;
          allowLocalDeployment = true;
        };
        imports = [agenix home-manager];
      };
      proxima = {
        deployment = {
          targetHost = "proxima";
        };
        imports = [agenix];
      };
      algedi = {
        deployment = {
          targetHost = "algedi.sinavir.fr";
        };
        imports = [agenix];
      };
      schedar = {
        deployment = {
          targetHost = "schedar";
        };
        imports = [agenix];
      };
      capella = {
        deployment = {
          targetHost = "capella";
          buildOnTarget = true;
        };
        imports = [agenix];
        arch = "aarch64-linux";
      };
      nekkar = {
        deployment = {
          targetHost = null;
        };
        nixpkgs = "nixos-netboot"; # overriding nixos for netboot as it takes time to build
      };
    };
  };
in
  metadata
