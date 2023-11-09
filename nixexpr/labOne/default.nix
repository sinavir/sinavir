{ nixpkgs ? (import ./npins).nixpkgs
,  pkgs ? import nixpkgs {}
}:
let
  patchedPkgs = pkgs.extend (import ./overlay.nix);
in
{
  labOne = patchedPkgs.labOne;
  python = patchedPkgs.python311.withPackages (ps: [
    ps.zhinst-meta
  ]);
}
