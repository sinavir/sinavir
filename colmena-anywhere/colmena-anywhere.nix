{ pkgs, nodes, node, host, extraArgs, ... }:
let
  inherit (nodes.${node}.config.system.build) diskoScript toplevel;
  colmenaAnywhere = pkgs.writeShellApplication {
    name = "colmena-anywhere-${node}";
    runtimeInputs = [ pkgs.nixosAnywhere ];
    text = ''
      nixos-anywhere -s ${diskoScript} ${toplevel} ${host} ${extraArgs}
    '';
  };
in {
  out = colmenaAnywhere;
  drvPath = colmenaAnywhere.drvPath;
  runPath = "${colmenaAnywhere}/bin/${colmenaAnywhere.name}";
}
