{ nixpkgs ? (import ./npins).nixpkgs
, pkgs ? import nixpkgs {}
}:
let
  python = pkgs.python311.override {
    packageOverrides = self: super: {
      gwyfile = self.callPackage ./gwyfile.nix {};
      zhinst-core = self.callPackage ./zhinst-core.nix {};
      zhinst-toolkit = self.callPackage ./zhinst-toolkit.nix {};
      zhinst-utils = self.callPackage ./zhinst-utils.nix {};
    };
  };
  zi2 = python.pkgs.callPackage ./zi2.nix {};
in
zi2
