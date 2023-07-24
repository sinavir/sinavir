{...}: {
  imports = [
    #./auto-upgrade.nix
    ./git-config.nix
    ./nix-conf.nix
    ./programs.nix
    ./secrets
    ./ssh.nix
    ./syncthing.nix
    ./users.nix
    ./nginx.nix
  ];
}
