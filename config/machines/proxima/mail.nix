{
  config,
  pkgs,
  ...
}: {
  services.dovecot2.sieve.extensions = [ "fileinto" ];

  mailserver = {
    enable = true;
    fqdn = "mail.sinavir.fr";
    domains = ["sinavir.fr"];

    # A list of all login accounts. To create the password hashes, use
    # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
    loginAccounts = {
      "sinavir@sinavir.fr" = {
        hashedPasswordFile = "/var/lib/mail/sinavir";
        aliases = ["maurice@sinavir.fr" "contact@sinavir.fr" "@sinavir.fr"];
        catchAll = ["sinavir.fr"];
        quota = "5G";
      };
      "vaultwarden@sinavir.fr" = {
        hashedPasswordFile = config.age.secrets."vaultMailPass".path;
        aliases = ["vaultwarden@sinavir.fr"];
        quota = "1G";
      };
      "sso@sinavir.fr" = {
        hashedPasswordFile = config.age.secrets."ssoMailPass".path;
        aliases = ["sso@sinavir.fr"];
        quota = "1G";
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
  services.roundcube = {
    enable = true;
    hostName = "mail.sinavir.fr";
    extraConfig = ''
      # starttls needed for authentication, so the fqdn required to match
      # the certificate
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  services.nginx.enable = true;

  networking.firewall.allowedTCPPorts = [80 443];
}
