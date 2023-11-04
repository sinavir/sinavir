let
  sources = import ./npins;
  metadata = import ./meta.nix;

  defaultNixpkgs = importNixpkgsPath sources."nixos-unstable";

  lib = defaultNixpkgs.lib.extend (import ./lib);

  mkNode = node: {
    ${node} = {
      name,
      nodes,
      ...
    }: {
      imports = [./machines/${node}/configuration.nix] ++ lib.attrByPath [ "imports" ] [] metadata.nodes.${node};
      inherit (metadata.nodes.${node}) deployment;
      nix.nixPath =
        builtins.map (n: "${n}=${sources.${n}}") (builtins.attrNames sources)
        ++ ["nixpkgs=${mkNixpkgsPath name}"];
      system.nixos.tags = [
        (builtins.fromJSON (builtins.readFile ./npins/sources.json)).pins.${pkgsVersion node}.revision
      ];
    };
  };

  pkgsVersion = node: lib.attrByPath [ node "nixpkgs" ] "nixos-unstable" metadata.nodes;

  mkNixpkgsPath = node: sources.${pkgsVersion node};

  mkNixpkgs = node: {
    ${node} = importNixpkgsPath (mkNixpkgsPath node);
  };

  importNixpkgsPath = p: import p {
    config.allowUnfree = true;
    overlays = import ./pkgs/overlays.nix;
  };

  nodes = builtins.attrNames metadata.nodes;

  concatAttrs = builtins.foldl' (x: y: x // y) {};
in
  {
    meta = {
      specialArgs = {inherit metadata;};
      nixpkgs = defaultNixpkgs;
      nodeNixpkgs = concatAttrs (builtins.map mkNixpkgs nodes);
      specialArgs = {
        lib = lib;
      };
    };
  }
  // (concatAttrs (builtins.map mkNode nodes))
