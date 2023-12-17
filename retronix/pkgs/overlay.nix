final: prev: {
  joy2keyd = final.python3.pkgs.callPackage ./joy2keyd {};
  retropieSetup = final.callPackage ./retropie-setup.nix {};
  joy2key = final.callPackage ./joy2key.nix {};
}
