let
  lib = (import <nixpkgs> {}).lib;
  readPubkeys = user:
    builtins.filter (k: k != "") (lib.splitString "\n"
      (builtins.readFile (../../../shared/pubkeys + "/${user}.keys")));
in {
  "vpn_preauth.age".publicKeys =
    (readPubkeys "maurice")
    ++ (readPubkeys "schedar");
  "ragb.age".publicKeys = (readPubkeys "maurice") ++ (readPubkeys "schedar");
  "ragbJWT.age".publicKeys = (readPubkeys "maurice") ++ (readPubkeys "schedar");
  "netbox.age".publicKeys =
    (readPubkeys "maurice")
    ++ (readPubkeys "schedar");
  "kitchenowl.age".publicKeys = (readPubkeys "schedar") ++ (readPubkeys "maurice");
  "bk-passwd.age".publicKeys = (readPubkeys "schedar") ++ (readPubkeys "maurice");
  "bk-key.age".publicKeys = (readPubkeys "schedar") ++ (readPubkeys "maurice");
}
