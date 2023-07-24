let
  lib = (import <nixpkgs> {}).lib;
  readPubkeys = user:
    builtins.filter (k: k != "") (lib.splitString "\n"
      (builtins.readFile (../../../shared/pubkeys + "/${user}.keys")));
in {
  "wg-polaris.age".publicKeys = (readPubkeys "polaris") ++ (readPubkeys "maurice");
  "bk-passwd.age".publicKeys = (readPubkeys "polaris") ++ (readPubkeys "maurice");
  "bk-key.age".publicKeys = (readPubkeys "polaris") ++ (readPubkeys "maurice");
}
