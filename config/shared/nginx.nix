{...}: {
  services.nginx = {
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    commonHttpConfig = ''add_header X-Robots-Tag "noindex, nofollow, nosnippet, noarchive";'';
  };

  security.acme = {
    defaults.email = "letsencrypt@sinavir.fr";
    acceptTerms = true;
  };
}
