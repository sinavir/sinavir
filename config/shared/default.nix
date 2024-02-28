{...}: {
  imports = [
    #./auto-upgrade.nix
    ./minimal-shared.nix
    ./git-config.nix # contains personal stuff
    ./secrets
    ./syncthing.nix
    ./nginx.nix
  ];
}
