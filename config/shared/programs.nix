{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    comma
    nurl
    lazygit
    agenix
    jq
    colmena
    dig
    git
    htop
    mosh
    screen
    npins
    nix-index
    tcpdump
    dhcpdump
    nixpkgs-fmt
    tree
    unzip
    vim
    wget
    wireguard-tools
    borgbackup
  ];

  programs.mosh.enable = !(builtins.elem config.networking.hostName []);
  programs.mtr.enable = true;

  programs.vim.defaultEditor = true;
}
