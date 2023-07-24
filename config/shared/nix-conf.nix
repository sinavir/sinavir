{
  lib,
  pkgs,
  config,
  metadata,
  nodes,
  name,
  ...
}: {
  nix.settings = {
    trusted-users = ["root" "@wheel"];
    auto-optimise-store = true;
    extra-experimental-features = ["nix-command" "flakes"];
  };
}
