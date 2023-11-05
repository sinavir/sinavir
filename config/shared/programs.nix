{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    agenix
    borgbackup
    colmena
    comma
    dhcpdump
    dig
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

  programs.mosh.enable = !(builtins.elem config.networking.hostName []);
  programs.mtr.enable = true;

  programs.vim.defaultEditor = true;
}
