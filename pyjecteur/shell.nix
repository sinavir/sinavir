{
  nixpkgs ? (import ./npins).nixpkgs
, pkgs ? import nixpkgs {}
}:
let
  python = pkgs.python310.override {
    packageOverrides = self: super: {
      pyjecteur = self.callPackage ./pyjecteur.nix {};
    };
  };
in
{
  dev = pkgs.mkShell {
    packages = [
      (pkgs.python310.withPackages (ps: [
        # build dep
        ps.pyserial
        ps.colour

        # dev dep
        ps.black
        ps.pylint
        ps.ipython
      ]))
      pkgs.pyright
    ];
  };
  prod = pkgs.mkShell {
    packages = [
      (python.withPackages (ps: [
        ps.pyjecteur

        ps.ipython
        ps.black
        ps.pylint
      ]))
      pkgs.pyright
    ];
  };
}
