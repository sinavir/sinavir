let
  sources = import ./npins;
  patchedSources = let
    patches = import ./patches;
  in
    lib.mapAttrs (name: value:
      if builtins.hasAttr name patches
      then stage0Nixpkgs.applyPatches {
        name = "${name}-patched";
        src = value;
        patches = patches.${name};
      }
      else value
    )
    sources;

  metadata = import ./meta.nix;

  defaultNixpkgs = importNixpkgsPath "x86_64-linux" patchedSources."nixos-unstable";

  stage0Nixpkgs = importNixpkgsPath "x86_64-linux" sources."nixos-unstable";

  lib = stage0Nixpkgs.lib.extend (import ./lib);

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
        builtins.map (n: "${n}=${patchedSources.${n}}") (builtins.attrNames patchedSources)
        ++ ["nixpkgs=${mkNixpkgsPath name}"];
      system.nixos.tags = [
        (revision node)
      ];
    };
  };

  pkgsVersion = node: lib.attrByPath [ node "nixpkgs" ] "nixos-unstable" metadata.nodes;

  mkNixpkgsPath = node: patchedSources.${pkgsVersion node};

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
