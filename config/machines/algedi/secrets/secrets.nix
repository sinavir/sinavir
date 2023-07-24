let
  lib = (import <nixpkgs> {}).lib;
  readPubkeys = user:
    builtins.filter (k: k != "") (lib.splitString "\n"
      (builtins.readFile (../../../shared/pubkeys + "/${user}.keys")));
in {
  "cdfanf-passwd.age".publicKeys = (readPubkeys "maurice") ++ (readPubkeys "algedi");
}
