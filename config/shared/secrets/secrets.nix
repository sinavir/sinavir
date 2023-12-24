let
  lib = (import <nixpkgs> {}).lib;
  readPubkeys = user:
    builtins.filter (k: k != "") (lib.splitString "\n"
      (builtins.readFile (../pubkeys + "/${user}.keys")));
  keys = (lib.concatMap readPubkeys [
    "maurice"
    "polaris"
    "schedar"
    "capella"
    "proxima"
    "algedi"
    "rigel"
  ]);
in {
  "ntfy.age".publicKeys =  keys;
  "knot-tsigNS2.age".publicKeys = lib.concatMap readPubkeys [ "maurice" "proxima" "schedar" ];
}
