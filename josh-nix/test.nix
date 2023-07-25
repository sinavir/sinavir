{ nixpkgs ? (import ./npins).nixpkgs
, pkgs ? import nixpkgs {},
}:
let
  nixos-lib = import (nixpkgs + "/nixos/lib") { };
in nixos-lib.runTest {
  name = "Test josh";
  hostPkgs = pkgs;
  nodes = {
    machine = {
      services.josh-proxy = {
        enable = true;
        settings.remotes = [ "http://localhost:8009" ];
        systemd.services.cgi = {
          script = ''
            GIT_DIR="/git" GIT_PROJECT_ROOT="/git" GIT_HTTP_EXPORT_ALL=1 hyper-cgi-test-server \
              --port=8001 \
              --dir="/git" \
              --cmd=${pkgs.git}/bin/git \
              --proxy "/real_repo.git/info/lfs=http://127.0.0.1:9999" \
              --args=http-backend
              '';

        };
      };
      environment.systemPackages = [
        (pkgs.writeShellApplication {
          name = "setupGit";
          runtimeInputs = [pkgs.git];
          text = ''
            mkdir /git
            export GIT_CONFIG_NOSYSTEM=1
            git init -q --bare "/git/test.git/"
          '';
        })
      ];
    };
  };
  testScript = ''
    start_all()
    
    machine.wait_for_unit("multi-user.service");
    machine.succeed("setupGit");
    machine.succeed("git clone http://localhost:8000/test.git:/a.git");
    '';
}
