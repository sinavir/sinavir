let
  sources = import ./npins;
  metadata = import ./meta.nix;

  lib = import ./lib.nix;

  mkNode = node: {
    ${node} = {
      name,
      nodes,
      ...
    }: {
      imports = [./machines/${node}/configuration.nix] ++ metadata.nodes.${node}.imports;
      inherit (metadata.nodes.${node}) deployment;
      nix.nixPath =
        builtins.map (n: "${n}=${sources.${n}}") (builtins.attrNames sources)
        ++ ["nixpkgs=${mkNixpkgsPath name}"];
    };
  };

  mkNixpkgsPath = node: let
    pkgs-version = lib.attrsOrDefault metadata.nodes.${node} "nixpkgs" "unstable";
  in
    sources."nixos-${pkgs-version}";

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
      nixpkgs = importNixpkgsPath sources."nixos-unstable";
      nodeNixpkgs = concatAttrs (builtins.map mkNixpkgs nodes);
    };
  }
  // (concatAttrs (builtins.map mkNode nodes))
