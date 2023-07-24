{
  pkgs,
  config,
  lib,
  ...
}: {
  age.secrets = {
    "vpn_preauth".file = ./vpn_preauth.age;
    "tsigNS2" = {
      file = ../../../shared/secrets/knot-tsigNS2.age;
      group = "knot";
      owner = "knot";
    };
    "wg-proxima" = {
      file = ./wg-proxima.age;
      group = "systemd-network";
      mode = "0440";
    };
    "plansPasswd" = {
      file = ./plans-passwd.age;
      owner = "nginx";
      group = "nginx";
    };
    "vaultwarden.env" = {
      file = ./vaultwarden.age;
      owner = "vaultwarden";
      group = "vaultwarden";
    };
    "vaultMailPass" = {
      file = ./vaultMailPass.age;
      owner = "dovecot2";
      group = "dovecot2";
    };
    "ssoMailPass" = {
      file = ./ssoMailPass.age;
      owner = "dovecot2";
      group = "dovecot2";
    };
    "radicale" = {
      file = ./radicale.age;
      owner = "radicale";
      group = "radicale";
    };
    "authelia_jwtSecret" = {
      file = ./authelia_jwtSecret.age;
      owner = "authelia-sinavir_sso";
      group = "authelia-sinavir_sso";
    };
    "authelia_storageEncryptionKey" = {
      file = ./authelia_storageEncryptionKey.age;
      owner = "authelia-sinavir_sso";
      group = "authelia-sinavir_sso";
    };
    "authelia_smtp_password" = {
      file = ./authelia_smtp_password.age;
      owner = "authelia-sinavir_sso";
      group = "authelia-sinavir_sso";
    };
    "authelia_oidcHmacSecret" = {
      file = ./authelia_oidcHmacSecret.age;
      owner = "authelia-sinavir_sso";
      group = "authelia-sinavir_sso";
    };
    "authelia_oidcIssuerPrivateKeyFile" = {
      file = ./authelia_oidcIssuerPrivateKeyFile.age;
      owner = "authelia-sinavir_sso";
      group = "authelia-sinavir_sso";
    };
    "oidc_headscale_secret" = {
      file = ./oidc_headscale_secret.age;
      owner = "headscale";
      group = "headscale";
    };
  };
}
