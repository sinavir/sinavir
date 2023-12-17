{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    agenix
    sqlite-web
    borgbackup
    colmena
    comma
    dhcpdump
    dig
    eza
    git
    htop
    jq
    lazygit
    mosh
    nix-index
    nixpkgs-fmt
    nmap
    npins
    nurl
    ripgrep
    screen
    tcpdump
    tree
    unzip
    vim
    wget
    wireguard-tools
  ];

  environment.shellAliases = {
    l = "eza -lah --git --git-repos-no-status";
  };

  programs.mosh.enable = !(builtins.elem config.networking.hostName []);
  programs.mtr.enable = true;

  programs.vim.defaultEditor = true;
}
