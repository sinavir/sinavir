let
  sources = import ./npins;
  metadata = import ./meta.nix;

  defaultNixpkgs = importNixpkgsPath "x86_64-linux" sources."nixos-unstable";

  lib = defaultNixpkgs.lib.extend (import ./lib);

  revision = node: (builtins.fromJSON (builtins.readFile ./npins/sources.json)).pins.${pkgsVersion node}.revision;

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
        (revision node)
      ];
    };
  };

  pkgsVersion = node: lib.attrByPath [ node "nixpkgs" ] "nixos-unstable" metadata.nodes;

  mkNixpkgsPath = node: sources.${pkgsVersion node};

  mkNixpkgs = node: {
    ${node} =
      importNixpkgsPath
      (lib.attrByPath [ "arch" ] "x86_64-linux" metadata.nodes.${node})
      (mkNixpkgsPath node);
  };

  importNixpkgsPath = arch: p: import p {
    config.allowUnfree = true;
    overlays = import ./pkgs/overlays.nix;
    system = arch;
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
