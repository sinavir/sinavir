let
  lib = (import <nixpkgs> {}).lib;
  readPubkeys = user:
    builtins.filter (k: k != "") (lib.splitString "\n"
      (builtins.readFile (../../../shared/pubkeys + "/${user}.keys")));
in {
  "wg-proxima.age".publicKeys =
    (readPubkeys "maurice")
    ++ (readPubkeys "proxima");
  "vpn_preauth.age".publicKeys =
    (readPubkeys "maurice")
    ++ (readPubkeys "proxima");
  "plans-passwd.age".publicKeys =
    (readPubkeys "maurice")
    ++ (readPubkeys "proxima");
  "vaultwarden.age".publicKeys =
    (readPubkeys "maurice")
    ++ (readPubkeys "proxima");
  "vaultMailPass.age".publicKeys =
    (readPubkeys "maurice")
    ++ (readPubkeys "proxima");
  "ssoMailPass.age".publicKeys =
    (readPubkeys "maurice")
    ++ (readPubkeys "proxima");
  "radicale.age".publicKeys = (readPubkeys "maurice") ++ (readPubkeys "proxima");
  "authelia_storageEncryptionKey.age".publicKeys = (readPubkeys "maurice") ++ (readPubkeys "proxima");
  "authelia_jwtSecret.age".publicKeys = (readPubkeys "maurice") ++ (readPubkeys "proxima");
  "authelia_oidcHmacSecret.age".publicKeys = (readPubkeys "maurice") ++ (readPubkeys "proxima");
  "authelia_oidcIssuerPrivateKeyFile.age".publicKeys = (readPubkeys "maurice") ++ (readPubkeys "proxima");

  "authelia_smtp_password.age".publicKeys = (readPubkeys "maurice") ++ (readPubkeys "proxima");
  "oidc_headscale_secret.age".publicKeys = (readPubkeys "maurice") ++ (readPubkeys "proxima");
}
